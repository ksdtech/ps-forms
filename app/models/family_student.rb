class FamilyStudent < ActiveRecord::Base
  belongs_to :version
  belongs_to :family
  belongs_to :student
  set_table_name :families_students
  
  def username
    powerschool_username.downcase
  end
  
  def password
    family.powerschool_password.downcase rescue nil
  end
  
  def find_user
    username.blank? ? nil : User.find(:first, :conditions => ['username=?', username])
  end
  
  def add_user
    if username.blank? || password.blank?
      puts "no username/password for family_student #{student.full_name} in #{family.home_id}"
    else
      u = find_user
      if !u.nil?
        puts "already have a user for family_student #{student.full_name}: username #{u.username}"
      else
        begin
          u = User.create(:email => "#{username}\@ps.kentfieldschools.org",
            :student_number => student.student_number,
            :home_id => family.home_id,
            :username => username,
            :password => password,
            :first_name => student.first_name,
            :last_name => student.last_name,
            :access_type => primary ? 'primary' : 'secondary')
          u.save
          rebuild_user_roles(u)
        rescue
          puts "failed to add user for family_student #{student.full_name}: #{$!}"
        end
      end
    end
  end
  
  def rebuild_user_roles(u = nil)
    u ||= find_user
    if !u.nil?
      parent_roles = u.user_roles.find(:all, :conditions => 
        ["role_id in (?)", User.all_parent_roles])
      u.user_roles.delete(parent_roles) if parent_roles.size > 0
      roles = [107]
      roles << 111 if student.schoolid == 103
      roles << 112 if student.schoolid == 104
      roles << (120 + student.grade_level)
      puts "family_parent #{u.username}: adding roles #{roles.join(',')}"
      roles.each do |role_id|
        u.user_roles.create(:role_id => role_id)
      end
    end
  end
  
  class << self
    def rebuild_user_roles(ver=nil)
      ver = Version.current if ver.nil?
      puts "rebuilding user roles"
      ver.family_students.each { |fs| fs.rebuild_user_roles }
    end
  end
  
end
