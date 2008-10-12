class Role < ActiveRecord::Base
  has_many :user_roles, :dependent => :delete_all
  has_many :users, :through => :user_roles
  
  LDAP_CONTAINER_ATTR = "cn"
  LDAP_CONTAINER_NAME = "groups"
  
  def cn
    name.downcase.gsub(/[^a-z0-9]+/, '-')
  end
  
  def dn
    "cn=#{cn},#{LDAP_CONTAINER_ATTR}=#{LDAP_CONTAINER_NAME},#{APP_CONFIG[:ldap_basedn]}"
  end
  
  def ldif_add_group(add_users=false)
    ldif = "dn: #{dn}\n" +
    "changetype: add\n" + 
    "objectclass: top\n" +
    "objectclass: posixGroup\n" +
    "gidNumber: #{id}\n" +
    "description: #{name}\n" +
    "cn: #{cn}\n\n"
    ldif << ldif_add_group_users if add_users
    ldif  
  end
  
  def ldif_add_group_users
    ldif = ''
    if users.size > 0
      cn = name.downcase
      ldif = "dn: #{dn}\n" +
      "changetype: modify\n" +
      "delete: memberUid\n"
      count = 0
      users.each do |u|
        if count == 0
          ldif << "\ndn: #{dn}\n" +
          "changetype: modify\n" + 
          "add: memberUid\n"
        end
        ldif << "memberUid: #{u.uid}\n"
        count += 1
      end
      ldif << "\n"
    end
    ldif
  end
  
  class << self
    def ldif_add_container
      "dn: #{LDAP_CONTAINER_ATTR}=#{LDAP_CONTAINER_NAME},#{APP_CONFIG[:ldap_basedn]}\n" +
      "changetype: add\n" + 
      "objectclass: top\n" + 
      "objectclass: container\n" + 
      "#{LDAP_CONTAINER_ATTR}: #{LDAP_CONTAINER_NAME}\n\n"
    end
    
    def ldif_modify_group_users(io, coll=nil)
      coll = find(:all, :order=>'name') if coll.nil?
      io << ldif_add_container
      coll.each { |r| io << r.ldif_add_group_users }
    end
    
    def ldif_add_groups(io, coll=nil)
      coll = find(:all, :order=>'name') if coll.nil?
      io << ldif_add_container
      coll.each { |r| io << r.ldif_add_group(true) }
    end
  end
end
