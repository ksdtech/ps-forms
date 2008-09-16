class Family < ActiveRecord::Base
  belongs_to :version
  has_many :family_students
  has_many :students, :through => :family_students, 
    :order => 'students.grade_level DESC, students.first_name'
  has_many :parents
  
  validates_numericality_of :home_id, :on => :create, :only_integer => true, :greater_than => 0
  
  def mailing_address
    stu = nil
    pre = nil
    family_students.each do |fs|
      pre = fs.primary? ? 'mailing_' : 'mailing2_'
      s = fs.student
      if !s["#{pre}street"].empty?
        stu = s
        break
      else
        pre = fs.primary? ? '' : 'home2_'
        if !s["#{pre}street"].empty?
          stu = s
        end
      end
    end
    return nil if stu.nil?
    [ pre, stu["#{pre}street"], stu["#{pre}city"], stu["#{pre}state"], stu["#{pre}zip"] ]
  end
  
  def rebuild_last_name
    ln_count = { }
    students.each do |s|
      ln = s.last_name.upcase
      ln_count[ln] ||= 0
      ln_count[ln] += 1
    end
    ln = ln_count.sort { |a,b| b[1] <=> a[1] }[0][0]
    puts "family #{self.home_id}: #{ln}"
    update_attribute(:last_name, ln)
  end

  def parent_names
    parents.collect { |p| p.full_name }.join(' and ')
  end
  
  def username_for_student(student_id)
    family_students.find(:first,
      :conditions => ["student_id=?", student_id]).powerschool_username
  end
  
  def password_letter(pdf, two_sided=false, header_text=nil)
    if two_sided
      pdf.start_new_page
      pdf.font_size 16 do
        pdf.move_down(72)
        pdf.font 'Helvetica-Bold'
        pdf.text(header_text) unless header_text.blank?
        pdf.text "To: #{parent_names}"
      end
    end
    pdf.start_new_page
    pdf.font_size 16 do
      pdf.font 'Helvetica-Bold'
      pdf.text(header_text) unless header_text.blank?
      pdf.text "To: #{parent_names}"
    end
    pdf.move_down 14
    pdf.font_size 14 do
      pdf.font 'Helvetica'
      pdf.text "Please help us keep your important contact and medical information" +
      " up to date.  We ask that you log in at"
      pdf.move_down 14
      pdf.text "http://ps.kentfieldschools.org"
      pdf.move_down 14
      pdf.text "with each of the usernames listed below.  Then click the 'Contacts'" + 
      " icon to verify and correct your contact and medical information.  If" +
      " you need to make any changes, make sure to click the 'Submit' button" +
      " at the bottom of each page you edit.  By keeping this information current" +
      " with any changes of address, phone numbers, email addresses, emergency" +
      " contacts, or medical conditions, you will help us improve our ability" +
      " to communicate with you and ensure the safety of your children in" +
      " case of an emergency.  Thank you in advance for your cooperation."
      version.students.each do |s|
        pdf.move_down 14
        pdf.font 'Helvetica-Bold'
        pdf.text "Login for #{s.full_name} (#{s.pretty_grade_level})"
        pdf.font 'Helvetica'
        pdf.text "Username: #{username_for_student(s.id)}"
        pdf.text "Password: #{powerschool_password}"
      end
    end
    pdf
  end

  class << self
    def home_ids(ver)
      ver.families.collect { |f| f.home_id }.uniq
    end
    
    def rebuild_last_names(ver)
      puts "rebuilding last names"
      ver.families.each { |fam| fam.rebuild_last_name }
    end
  end
end
