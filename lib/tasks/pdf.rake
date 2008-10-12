namespace :pdf do

  desc "generate bacich emergency forms pdf"
  task :emerg_bacich => :environment do
    RegFormPDF.export_bacich_emergency_forms('2008-b')
  end
  
  desc "generate kent emergency forms pdf"
  task :emerg_kent => :environment do
    RegFormPDF.export_kent_emergency_forms('2008-k')
  end
  
  desc "gerneate a test registration form pdf"
  task :reg_test => :environment do
    RegFormPDF.reg_forms([Student.find(:first)], 'reg_test.pdf')
  end

  desc "generate a test emergency form pdf"
  task :emerg_test => :environment do
    RegFormPDF.emergency_forms([Student.find(:first)], 'emerg_test.pdf')
  end

end