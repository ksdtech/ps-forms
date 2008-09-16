class ParentContactItem < ActiveRecord::Base
  belongs_to :version
  belongs_to :parent
  belongs_to :contact_item
end
