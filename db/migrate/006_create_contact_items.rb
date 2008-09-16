class CreateContactItems < ActiveRecord::Migration
  def self.up
    create_table :contact_items, :force => true do |t|
      t.integer :version_id
      t.string  :contact_type, :null => false
      t.string  :location
      t.boolean :primary, :null => false, :default => false
      t.string  :value, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :contact_items
  end
end
