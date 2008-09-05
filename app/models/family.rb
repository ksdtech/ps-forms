class Family < ActiveRecord::Base
  has_many :family_students
  has_many :students, :through => :family_students
  
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
  
  class << self
    def home_ids
      find(:all).collect { |f| f.home_id }.uniq
    end
    
    def rebuild_last_names
      puts "rebuilding last names"
      find(:all).each { |fam| fam.rebuild_last_name }
    end
  end
end
