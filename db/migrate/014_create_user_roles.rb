class CreateUserRoles < ActiveRecord::Migration
  def self.up
    create_table :user_roles, :force => true do |t|
      t.integer :user_id, :null => false, :default => 0
      t.integer :role_id, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :user_roles
  end
end
