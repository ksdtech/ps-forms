class CreateParentContactItems < ActiveRecord::Migration
  def self.up
    create_table :parent_contact_items, :force => true do |t|
      t.integer :version_id, :null => false, :default => 0
      t.integer :parent_id, :null => false, :default => 0
      t.integer :contact_item_id, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :parent_contact_items
  end
end
