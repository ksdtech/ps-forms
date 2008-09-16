class Event < ActiveRecord::Base
  belongs_to :version
  belongs_to :table_row, :polymorphic => true
  belongs_to :related_row, :polymorphic => true
end
