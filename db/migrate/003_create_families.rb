class CreateFamilies < ActiveRecord::Migration
  def self.up
    create_table :families, :force => true do |t|
      t.integer :home_id, :null => false, :default => 0
      t.string :last_name
      t.timestamps
    end
  end

  def self.down
    drop_table :families
  end
end
