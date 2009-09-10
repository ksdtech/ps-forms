namespace :import do
  desc "clear all versions"
  task :clear_all => :environment do
    Version.find(:all).each do |v|
      v.destroy
    end
    UserRole.delete_all
    User.delete_all
  end  
  
  desc "just students"
  task :students => :clear_all do
    Student.import(nil, 'students.txt', :students_only => true)
  end

  desc "staff, students, families, etc"
  task :all => :clear_all do
    version_id = Employee.import(nil, 'staff.txt')
    Student.import(version_id, 'students.txt', :students_only => false)
  end  
end
  