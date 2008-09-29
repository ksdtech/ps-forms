namespace :pdf do
  desc "test emergency forms"
  task :emerg_test => :environment do
    RegFormPDF.emergency_forms([Student.find(:first)], 'test.pdf')
  end

  desc "bacich emergency forms"
  task :emerg_bacich => :environment do
    RegFormPDF.export_bacich_emergency_forms('2008-b')
  end
  
  desc "test registration forms"
  task :reg_test => :environment do
    RegFormPDF.reg_forms([Student.find(:first)], 'test.pdf')
  end

end