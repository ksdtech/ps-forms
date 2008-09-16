class CreateParentContactItems < ActiveRecord::Migration
  def self.up
    create_table :parent_contact_items, :force => true do |t|
      t.integer :version_id
      t.integer :parent_id
      t.integer :contact_item_id
      t.timestamps
    end
  end

  def self.down
    drop_table :parent_contact_items
  end
end
