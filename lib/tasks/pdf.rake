namespace :pdf do
  desc "generate a test registration form pdf"
  task :reg_test => :environment do
    RegFormPDF.reg_forms([Student.find(:first)], "#{Rails.root}/data/reg_test.pdf")
  end

  desc "generate a blank kindergarten registration form pdf"
  task :reg_kg => :environment do
    s = Student.new(:grade_level => 0, :enroll_status => 0)
    RegFormPDF.reg_forms([s], "#{Rails.root}/data/reg_blank.pdf", true)
    RegFormPDF.emergency_forms([s], "#{Rails.root}/data/emerg_blank.pdf", true)
  end

  desc "generate bacich registration forms pdf"
  task :reg_bacich => :environment do
    RegFormPDF.export_bacich_reg_forms("#{Rails.root}/data/2009-br")
  end
  
  desc "generate kent registration forms pdf"
  task :reg_kent => :environment do
    RegFormPDF.export_kent_reg_forms("#{Rails.root}/data/2009-kr")
  end
  
  desc "generate a test emergency form pdf"
  task :emerg_test => :environment do
    RegFormPDF.emergency_forms([Student.find(:first)], "#{Rails.root}/data/emerg_test.pdf")
  end
  
  desc "emergency forms for new bacich students"
  task :emerg_bacich_new => :environment do
    coll = Student.find(:all, :conditions => ['schoolid=? AND entrycode IN (?)', 103, ['ND','RD']],
      :order => 'last_name,first_name')
    RegFormPDF.emergency_forms(coll, "#{Rails.root}/data/2009-bx-new.pdf")
  end
  
  desc "emergency forms for new kent students"
  task :emerg_kent_new => :environment do
    coll = Student.find(:all, :conditions => ['schoolid=? AND entrycode IN (?)', 104, ['ND','RD']],
      :order => 'last_name,first_name')
    RegFormPDF.emergency_forms(coll, "#{Rails.root}/data/2009-bx-new.pdf")
  end
  
  desc "generate bacich emergency forms pdf"
  task :emerg_bacich => :environment do
    RegFormPDF.export_bacich_emergency_forms("#{Rails.root}/data/2009-bx")
  end
  
  desc "generate per grade bacich emergency forms"
  task :emerg_grades => :environment do
    order = 'home_room,last_name,first_name'
    conds = ['enroll_status<=0 AND schoolid=? AND grade_level=?', 103, 0]
    RegFormPDF.export_forms('grade_k', nil, order, 103, false, true, 'output_emergency_forms', conds)
    conds = ['enroll_status<=0 AND schoolid=? AND grade_level=?', 103, 1]
    RegFormPDF.export_forms('grade_1', nil, order, 103, false, true, 'output_emergency_forms', conds)
    conds = ['enroll_status<=0 AND schoolid=? AND grade_level=?', 103, 2]
    RegFormPDF.export_forms('grade_2', nil, order, 103, false, true, 'output_emergency_forms', conds)
  end
  
  desc "generate kent emergency forms pdf"
  task :emerg_kent => :environment do
    RegFormPDF.export_kent_emergency_forms("#{Rails.root}/data/2009-kx")
  end  
  
  desc "all bacich forms pdf"
  task :bacich_forms => :environment do
    RegFormPDF.export_bacich_reg_forms("#{Rails.root}/data/2009-br")
    RegFormPDF.export_bacich_emergency_forms("#{Rails.root}/data/2009-bx")
  end  
  
  desc "all kent forms pdf"
  task :kent_forms => :environment do
    RegFormPDF.export_kent_reg_forms("#{Rails.root}/data/2009-kr")
    RegFormPDF.export_kent_emergency_forms("#{Rails.root}/data/2009-kx")
  end  

end