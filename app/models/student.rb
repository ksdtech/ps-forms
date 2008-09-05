class Student < ActiveRecord::Base
  has_many :family_students
  has_many :families, :through => :family_students

  validates_presence_of :last_name, :on => :create
  validates_presence_of :first_name, :on => :create
  validates_numericality_of :student_number, :on => :create, :only_integer => true, :greater_than => 0
  validates_numericality_of :schoolid, :on => :create, :only_integer => true
  validates_numericality_of :grade_level, :on => :create, :only_integer => true
  validates_numericality_of :enroll_status, :on => :create, :only_integer => true
  validates_numericality_of :home_id, :on => :create, :only_integer => true, :greater_than => 0
  
  def add_to_family(family_id, prim)
    puts "#{self.student_number} add_to_family #{family_id}"
    f = Family.find_by_home_id(family_id)
    if f.nil?
      begin
        f = Family.new(:home_id => family_id)
        f.save
      rescue
        raise
      end
    end
    begin
      fs = self.family_students.build(:family_id => f.id, :primary => prim)
      fs.save(false)
    rescue
      raise
    end
  end
  
  class << self
    
    # The file students.txt is created with Names-Families-All-Contact-Info 
    # export template.
    def import(fname='students.txt')
      Student.delete_all
      FamilyStudent.delete_all
      Family.delete_all
      s_count = 0
      fname = File.join(RAILS_ROOT, 'db', fname) unless fname[0,1] == '/'
      FasterCSV.foreach(fname, :col_sep => "\t", :row_sep => "\n", 
        :headers => true, :header_converters => :symbol) do |row|
        begin
          attrs = row.to_hash
          attrs[:home_id] = 0 if attrs[:home_id].nil?
          if attrs[:home_id].to_i == 0
            puts "no primary family for student #{row[:student_number]}"
            next
          end
          sid = attrs[:schoolid]
          if sid != '104' && sid != '103'
            puts "invalid school for student #{row[:student_number]}"
            next
          end
          attrs[:home2_id] = 0 if attrs[:home2_id].nil?
          puts "new student #{row[:student_number]}"
          s = Student.new(attrs)
          s.save
          s.add_to_family(s.home_id, true) if s.home_id != 0
          s.add_to_family(s.home2_id, false) if s.home2_id != 0
          s_count += 1
          # break if s_count == 20
        rescue
          raise
        end
      end
      
      Family.rebuild_last_names
    end
    
  end
end
