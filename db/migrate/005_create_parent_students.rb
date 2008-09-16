class CreateParentStudents < ActiveRecord::Migration
  def self.up
    create_table :parent_students, :force => true do |t|
      t.integer :version_id
      t.integer :student_id
      t.integer :parent_id
      t.string  :link
      # t.string :relationship
      t.timestamps
    end
  end

  def self.down
    drop_table :parent_students
  end
end
