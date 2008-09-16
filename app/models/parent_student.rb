class ParentStudent < ActiveRecord::Base
  belongs_to :version
  belongs_to :parent
  belongs_to :student
end
