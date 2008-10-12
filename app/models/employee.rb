require 'contact_item'

class Employee < ActiveRecord::Base
  belongs_to :version
  has_many :employee_contact_items
  has_many :phones, :through => :employee_contact_items, 
    :source => :contact_item,
    :conditions => "contact_items.contact_type='Phone'"
  has_many :emails, :through => :employee_contact_items, 
    :source => :contact_item,
    :conditions => "contact_items.contact_type='Email'"
    
  def full_name
    "#{first_name} #{last_name}".strip
  end    

  def parent
    version.parents.find(:first, :conditions => ['staff_id=?', teachernumber])
  end

  def add_email(email, primary=false)
    email, valid, reformatted = Email.canonicalize(email)
    if valid
      puts "employee #{self.teachernumber} adding email #{email}"
      ver = self.version
      em = emails.find_by_value(email)
      if em.nil?
        em = ver.contact_items.create(:contact_type => 'Email',
          :primary => primary, :value => email)
        ver.employee_contact_items.create(:employee_id => self.id, :contact_item_id => em.id)
      end
    end
  end
  
  def add_phone(phone, location)
    phone, valid, reformatted = Phone.canonicalize(phone)
    if valid
      puts "employee #{self.teachernumber} adding phone #{phone}"
      ver = self.version
      ph = phones.find_by_value(phone)
      if ph.nil?
        ph = ver.contact_items.create(:contact_type => 'Phone', 
          :location => location, :value => phone)
        ver.employee_contact_items.create(:employee_id => self.id, :contact_item_id => ph.id)
      end
    end
  end
  
  def primary_email
    em = emails.find(:first, :conditions => ['`contact_items`.primary=1'])
    em.nil? ? nil : em.value
  end
  
  def username(em=nil)
    em = primary_email if em.nil?
    (status == 1 && !em.nil? && !network_id.blank? && 
      !network_password.blank? && network_password != '*' &&
       emails.count(:conditions => ['`contact_items`.primary=1']) !=0 ) ? network_id : nil
  end
  
  def find_user(un=nil, em=nil)
    un = username(em) if un.nil?
    u = User.find(:first, :conditions => ['username=?', un]) if !un.nil?
    if u.nil?
      em = primary_email if em.nil?
      if !em.nil?
        u = User.find(:first, :conditions => ['email=?', em]) if !em.nil?
      end
    end
    u
  end
  
  def add_user
    em = primary_email
    if status == 1 && !em.nil? && !network_id.blank? && 
        !network_password.blank? && network_password != '*'
      u = find_user(network_id, em)
      if !u.nil?
        puts "already have a user for employee #{full_name}: email #{u.email} or username #{u.username}"
        u.update_attributes(:staff_id => teachernumber)
      else
        puts "adding user for employee #{full_name} #{teachernumber}"
        begin
          u = User.create(:email => em,
            :username => network_id, 
            :password => network_password,
            :first_name => first_name,
            :last_name => last_name,
            :staff_id => teachernumber)
          u.save
        rescue
          puts "failed to add user for employee #{full_name} #{teachernumber}: #{$!}"
          u = nil
        end
      end
    else
      puts "not adding user for employee #{full_name} #{teachernumber}"
    end
    if !u.nil?
      rebuild_user_roles(u)
    end
  end
  
  def rebuild_user_roles(u=nil)
    u = find_user if u.nil?
    if !u.nil?
      staff_roles = u.user_roles.find(:all, :conditions => 
        ["role_id in (?)", User.all_staff_roles])
      u.user_roles.delete(staff_roles) if staff_roles.size > 0
      roles = User.staff_groups_to_roles('staff-all ' + groups)
      puts "employee #{u.full_name}: adding roles #{roles.join(',')}"
      roles.each do |role_id|
        u.user_roles.create(:role_id => role_id)
      end
    end
  end
  
  def validate_all
    validate_user
  end
  
  def validate_user
  end

  class << self
    def has_attribute?(key)
      (@col_keys ||= column_names).include?(key.to_s)
    end
    
    # The file students.txt is created with Names-Families-All-Contact-Info 
    # export template.
    def import(ver=nil, fname='staff.txt', options={})
      options = { :col_sep => "\t", :row_sep => "\n" }.update(options)
      e_count = 0
      fname = File.join(RAILS_ROOT, 'data', fname) unless fname[0,1] == '/'
      UnquotedCSV.foreach(fname, 
        :col_sep => options[:col_sep], :row_sep => options[:row_sep],
        :headers => true, :header_converters => :symbol) do |row|
        begin
          attrs = row.to_hash
          sid = attrs[:schoolid]
          if sid != '104' && sid != '103' && sid != '102'
            puts "invalid school for employee #{row[:teachernumber]}"
            next
          end
          puts "new employee #{row[:teachernumber]}"
          employee_attrs = attrs.reject { |k, v| !Employee.has_attribute?(k) }
          employee_attrs[:groups] ||= ''
          if ver.nil?
            ver = Version.create
          elsif ver.is_a?(Fixnum)
            ver = Version.find(ver)
          end
          e = ver.employees.build(employee_attrs)
          e.save
          if !e.email_addr.blank?
            e.add_email(e.email_addr, true)
            e.add_email(e.email_personal, false) if !e.email_personal.blank?
          else
            e.add_email(e.email_personal, true) if !e.email_personal.blank?
          end
          e.add_phone(e.home_phone, 'Home') if !e.home_phone.blank?
          e.add_phone(e.cell, 'Cell') if !e.cell.blank?
          e.add_user
          e_count += 1
          # break if e_count == 20
        rescue
          raise
        end
      end
      ver.id
    end
    
  end
  
end
