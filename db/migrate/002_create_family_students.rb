class CreateFamilyStudents < ActiveRecord::Migration
  def self.up
    create_table :families_students, :force => true do |t|
      t.integer :version_id, :null => false, :default => 0
      t.integer :student_id, :null => false, :default => 0
      t.integer :family_id, :null => false, :default => 0
      t.boolean :primary, :null => false, :default => true
      t.string  :powerschool_username
      t.timestamps
    end
  end

  def self.down
    drop_table :families_students
  end
end
