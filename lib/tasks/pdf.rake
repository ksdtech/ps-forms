namespace :pdf do

  desc "generate a test registration form pdf"
  task :reg_test => :environment do
    RegFormPDF.reg_forms([Student.find(:first)], 'reg_test.pdf')
  end

  desc "generate bacich registration forms pdf"
  task :reg_bacich => :environment do
    RegFormPDF.export_bacich_reg_forms('2008-br')
  end
  
  desc "generate kent registration forms pdf"
  task :reg_kent => :environment do
    RegFormPDF.export_kent_reg_forms('2008-kr')
  end
  
  desc "generate a test emergency form pdf"
  task :emerg_test => :environment do
    RegFormPDF.emergency_forms([Student.find(:first)], 'emerg_test.pdf')
  end
  
  desc "generate bacich emergency forms pdf"
  task :emerg_bacich => :environment do
    RegFormPDF.export_bacich_emergency_forms('2008-bx')
  end
  
  desc "generate kent emergency forms pdf"
  task :emerg_kent => :environment do
    RegFormPDF.export_kent_emergency_forms('2008-kx')
  end
  

end