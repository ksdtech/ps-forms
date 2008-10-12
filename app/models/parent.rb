class Parent < ActiveRecord::Base
  belongs_to :version
  belongs_to :family
  has_many :parent_students
  has_many :students, :through => :parent_students
  has_many :parent_contact_items
  has_many :phones, :through => :parent_contact_items, 
    :source => :contact_item,
    :conditions => "contact_items.contact_type='Phone'"
  has_many :emails, :through => :parent_contact_items, 
    :source => :contact_item,
    :conditions => "contact_items.contact_type='Email'"
    
  after_save :check_zero_staff_id
  
  def check_zero_staff_id
    raise if staff_id == 0
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end
  
  def home_id
    fam = self.family
    hid = fam.nil? ? nil : fam.home_id
    hid == 0 ? nil : hid
  end
    
  def base_username
    "#{first_name[0,1]}#{last_name}".downcase.gsub(/[^a-z]/, '').strip
  end
  
  def employee
    return nil if staff_id.nil?
    version.employees.find(:first, :conditions => ['teachernumber=?', staff_id])
  end
  
  def add_email(email, primary=false)
    email, valid, reformatted = Email.canonicalize(email)
    if valid
      ver = self.version
      em = emails.find_by_value(email)
      if em.nil?
        em = ver.contact_items.create(:contact_type => 'Email',
          :primary => primary, :value => email)
        ver.parent_contact_items.create(:parent_id => self.id, :contact_item_id => em.id)
      end
    end
  end
  
  def add_phone(phone, location)
    phone, valid, reformatted = Phone.canonicalize(phone)
    if valid
      ver = self.version
      ph = phones.find_by_value(phone)
      if ph.nil?
        ph = ver.contact_items.create(:contact_type => 'Phone', 
          :location => location, :value => phone)
        ver.parent_contact_items.create(:parent_id => self.id, :contact_item_id => ph.id)
      end
    end
  end
  
  def primary_email
    em = emails.find(:first, :conditions => ['`contact_items`.primary=1'])
    em.nil? ? nil : em.value
  end
  
  def find_user
    u = nil
    empl = employee
    if !empl.nil?
      un = empl.username
      u = User.find(:first, :conditions => ['username=?', un]) if !un.nil?
    end
    if u.nil?
      em = primary_email
      if !em.nil?
        u = User.find(:first, :conditions => ['email=?', em])
      end
    end
    u
  end
  
  def add_user
    attrs = { :home_id => home_id }
    attrs[:staff_id] = staff_id unless staff_id.nil? || staff_id == 0
    u = find_user
    if !u.nil?
      puts "already have a user for parent #{full_name}: email #{u.email} or username #{u.username}"
      u.update_attributes(attrs)
    else
      em = primary_email
      if !em.nil?
        b_username = base_username
        username = b_username
        sanity = 0
        while sanity < 100
          break if User.count(:conditions => ['username=?', username]) == 0
          sanity += 1
          username = "#{b_username}#{sanity}"
        end
        if sanity == 100
          puts "could not generate a unique username for parent #{full_name}"
        else
          begin
            u = User.create(attrs.update(:email => em,
              :username => username, 
              :password => APP_CONFIG[:parent_temp_password],
              :first_name => first_name,
              :last_name => last_name))
            u.save
            ur = u.user_roles.build(:role_id => 107)
            ur.save
          rescue
            puts "failed to add user for parent #{full_name}: #{$!}"
          end
        end
      end
    end
  end
    
  def rebuild_user_roles
    u = find_user
    if !u.nil?
      parent_roles = u.user_roles.find(:all, :conditions => 
        ["role_id in (?)", User.all_parent_roles])
      u.user_roles.delete(parent_roles) if parent_roles.size > 0
      roles = students.inject([107]) do |a, s|
        a << 111 if s.schoolid == 103
        a << 112 if s.schoolid == 104
        a << (120 + s.grade_level)
        a
      end.uniq
      puts "parent #{u.full_name}: adding roles #{roles.join(',')}"
      roles.each do |role_id|
        u.user_roles.create(:role_id => role_id)
      end
    end
  end
  
  class << self
    def rebuild_user_roles(ver=nil)
      ver = Version.current if ver.nil?
      puts "rebuilding user roles"
      ver.parents.each { |p| p.rebuild_user_roles }
    end
  end
  
end
