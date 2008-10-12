class CreateParents < ActiveRecord::Migration
  def self.up
    create_table :parents, :force => true do |t|
      t.integer :version_id, :null => false, :default => 0
      t.integer :family_id, :null => false, :default => 0
      t.integer :staff_id
      t.string  :parent_number
      t.string  :last_name
      t.string  :first_name
      t.timestamps
    end
  end

  def self.down
    drop_table :parents
  end
end
