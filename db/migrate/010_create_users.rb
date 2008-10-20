class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string  :email, :limit => 60, :null => false
      t.string  :username, :limit => 30, :null => false
      t.string  :password, :limit => 30, :null => false
      t.string  :first_name, :limit => 30
      t.string  :last_name, :limit => 30
      t.integer :home_id
      t.integer :staff_id
      t.integer :student_number
      t.string  :access_type
      t.timestamps
    end
    
    add_index('users', 'email', :unique => true)
    add_index('users', 'username', :unique => true)
  end

  def self.down
    drop_table :users
  end
end
