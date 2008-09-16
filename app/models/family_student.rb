class FamilyStudent < ActiveRecord::Base
  belongs_to :version
  belongs_to :family
  belongs_to :student
  set_table_name :families_students
  
end
