namespace :import do
  desc "just students"
  task :students => :environment do
    Student.import(nil, 'students.txt', :students_only => true)
  end

  desc "students, families, etc"
  task :validation => :environment do
    Student.import(nil, 'students.txt', :students_only => false)
  end
end
  