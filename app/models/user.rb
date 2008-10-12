class User < ActiveRecord::Base
  has_many :user_roles, :dependent => :delete_all
  has_many :roles, :through => :user_roles, :order => 'id'
  
  LDAP_CONTAINER_ATTR = "cn"
  LDAP_CONTAINER_NAME = "users"
  
  KSDORG_STAFF_ROLES = {
    'administrators' => 110,
    'aides-bacich' => 0,
    'aides-kent' => 0,
    'arts' => 0,
    'classified-all' => 0,
    'classified-bacich' => 0,
    'classified-district' => 0,
    'classified-kent' => 0,
    'communications' => 0,
    'connections' => 0,
    'ela' => 0,
    'eld' => 0,
    'enrichment' => 0,
    'glcs-bacich' => 0,
    'glcs-kent' => 0,
    'guidance-kent' => 0,
    'history' => 0,
    'kta' => 0,
    'library' => 131,
    'math' => 0,
    'math-bacich' => 0,
    'pe' => 0,
    'pslogs-bacich' => 0,
    'pslogs-kent' => 0,
    'rsp' => 0,
    'rsp-bacich' => 0,
    'rsp-kent' => 0,
    'science' => 0,
    'spanish' => 0,
    'staff-5' => 0,
    'staff-all' => 109,
    'staff-bacich' => 117,
    'staff-district' => 0,
    'staff-kent' => 118,
    'teachers-1' => 0,
    'teachers-2' => 0,
    'teachers-3' => 0,
    'teachers-4' => 0,
    'teachers-5' => 0,
    'teachers-6' => 0,
    'teachers-7' => 0,
    'teachers-8' => 0,
    'teachers-all' => 106,
    'teachers-bacich' => 115,
    'teachers-kent' => 116,
    'teachers-kg' => 0,
    'trustees' => 113,
    'tug' => 0,
    'tug-bacich' => 0,
    'tug-kent' => 0,
    'vanguard' => 0,
  }
  
  KSDORG_PARENT_ROLES = [107,111,112,120,121,122,123,124,125,126,127,128]
  
  def crypted_password
    User.crypted(password)
  end
  
  def full_name
    "#{first_name} #{last_name}".strip
  end
  
  def ldif_roles
    roles.collect { |r| r.id.to_s }.join("*")
  end
  
  def ldif_employee_type
    emp_hash = []
    emp_hash.push("staff:#{staff_id}") unless staff_id.nil?
    emp_hash.push("family:#{home_id}") unless home_id.nil?
    emp_hash.push("student:#{student_number}") unless student_number.nil?
    emp_hash.join(',')
  end
  
  def uid 
    self.username
  end
  
  def dn
    "uid=#{uid},#{LDAP_CONTAINER_ATTR}=#{LDAP_CONTAINER_NAME},#{APP_CONFIG[:ldap_basedn]}"
  end
  
  def ldif_add_user
    ldif = "dn: #{dn}\n" +
    "changetype: add\n" + 
    "objectclass: top\n" +
    "objectclass: person\n" +
    "objectclass: organizationalPerson\n" +
    "objectclass: inetOrgPerson\n" +
    "objectclass: schoolwiresUser\n" + 
    "uid: #{username}\n" +
    "description: #{ldif_roles}\n" +
    "employeeType: #{ldif_employee_type}\n" +
    "cn: #{full_name}\n" +
    "givenName: #{first_name}\n" +
    "sn: #{last_name}\n" +
    "mail: #{email}\n" +
    "userPassword: {crypt}#{crypted_password}\n"
    
    roles.each do |r|
      ldif << "swUserRole: #{r.dn}\n"
    end
    
    ldif << "\n" 
    ldif
  end
  
  
  def will_change_password(new_password)
    new_password != password
  end
  
  def ldap_change_password(new_password)
    errno = -1
    begin
      IO.popen(APP_CONFIG[:ldap_modify], 'w') do |f|
        f.puts ldif_change_password(new_password)
      end
      errno = $?
    rescue
    end
    return errno == 0
  end

  def ldif_change_password(new_password=nil)
    new_password = password if new_password.blank?
    "dn: #{dn}\n" +
    "changetype: modify\n" +
    "replace: userPassword\n" + 
    "userPassword: {crypt}#{User.crypted(new_password)}\n\n"
  end
  
  class << self
    def crypted(s)
      salt = [ rand(64), rand(64) ].collect do |i|
        "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"[i, 1]
      end.join('')
      s.crypt(salt)
    end
    
    def ldif_add_container
      "dn: #{LDAP_CONTAINER_ATTR}=#{LDAP_CONTAINER_NAME},#{APP_CONFIG[:ldap_basedn]}\n" +
      "changetype: add\n" + 
      "objectclass: top\n" + 
      "objectclass: container\n" + 
      "#{LDAP_CONTAINER_ATTR}: #{LDAP_CONTAINER_NAME}\n\n"
    end
    
    def ldif_add_users(io, coll=nil)
      coll = find(:all, :order=>'last_name,first_name') if coll.nil?
      io << ldif_add_container
      coll.each { |u| io << u.ldif_add_user }
    end
    
    def staff_groups_to_roles(s)
      groups = s.split(/[^-_A-Za-z0-9]+/)
      groups.inject([]) do |a, g|
        role_id = KSDORG_STAFF_ROLES.fetch(g, 0)
        a << role_id if role_id != 0
        a
      end.uniq
    end
    
    def all_staff_roles
      @all_staff_roles ||= KSDORG_STAFF_ROLES.select { |k,v| v != 0 }.collect { |kv| kv[1] }
    end
    
    def all_parent_roles
      KSDORG_PARENT_ROLES
    end
    
    def export_sw_users(coll=nil, fname='sw_users.csv')
      coll = User.find(:all) if coll.nil?
      File.open(fname, "w") do |f|
        header = %w{ FirstName LastName UserName Roles Email Password }
        f.write header.join(',')
        f.write "\r\n"
        coll.each do |u|
          roles = u.roles.collect { |r| r.id }
          row = [u.first_name, u.last_name, u.username, roles.join("*"), u.email, u.password ]
          f.write row.join(',')
          f.write "\r\n"
        end
      end
    end
  end
  
end
