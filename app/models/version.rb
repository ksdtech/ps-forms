class Version < ActiveRecord::Base
  has_many :students, :dependent => :delete_all
  has_many :employees, :dependent => :delete_all
  has_many :families, :dependent => :delete_all
  has_many :family_students, :dependent => :delete_all
  has_many :parents, :dependent => :delete_all
  has_many :parent_students, :dependent => :delete_all
  has_many :contact_items, :dependent => :delete_all
  has_many :employee_contact_items, :dependent => :delete_all
  has_many :parent_contact_items, :dependent => :delete_all
  has_many :events, :dependent => :delete_all
  has_many :diff_events, :class_name => 'Event', :foreign_key => 'diff_version_id',
    :dependent => :delete_all
  
  def name
    created_at
  end

  def validate_all
    av = AggregateValidation.new(self)
    employees.each { |e| e.validate_all }
    students.each { |s| s.validate_all(av) }
    av.analyze_results
  end
  
  class << self
    def current
      Version.find(:first, :order => ["created_at DESC"]) || Version.create
    end
  end
end
