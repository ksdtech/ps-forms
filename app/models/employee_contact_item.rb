class EmployeeContactItem < ActiveRecord::Base
  belongs_to :version
  belongs_to :employee
  belongs_to :contact_item
end
