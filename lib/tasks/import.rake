namespace :import do
  desc "just students"
  task :students => :environment do
    Student.import(nil, 'students.txt', :students_only => true)
  end

  desc "staff, students, families, etc"
  task :all => :environment do
    version_id = Employee.import(nil, 'staff.txt')
    Student.import(version_id, 'students.txt', :students_only => false)
  end  
  
  desc "clear all versions"
  task :clear_all => :environment do
    Version.find(:all).each do |v|
      v.destroy
    end
    UserRole.delete_all
    User.delete_all
  end  
end
  