class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students, :force => true do |t|
      t.integer :student_number, :null => false, :default => 0
      t.string :last_name
      t.string :first_name
      t.string :nickname
      t.integer :schoolid, :null => false, :default => 0
      t.integer :grade_level, :null => false, :default => 0
      t.integer :enroll_status, :null => false, :default => 0
      t.string :home_room
      t.string :homeroom_teacher
      t.string :homeroom_teacherfirst
      t.string :guardianemail
      t.integer :home_id, :null => false, :default => 0
      t.string :street
      t.string :state
      t.string :city
      t.string :zip
      t.string :mailing_street
      t.string :mailing_state
      t.string :mailing_city
      t.string :mailing_zip
      t.string :home_phone
      t.string :mother
      t.string :mother_home_phone
      t.string :mother_work_phone
      t.string :mother_cell
      t.string :mother_first
      t.string :mother_email
      t.string :mother_email2
      t.string :father
      t.string :father_first
      t.string :father_home_phone
      t.string :father_work_phone
      t.string :father_cell
      t.string :father_email
      t.string :father_email2
      t.integer :home2_id, :null => false, :default => 0
      t.string :home2_street
      t.string :home2_state
      t.string :home2_city
      t.string :home2_zip
      t.string :mailing2_street
      t.string :mailing2_state
      t.string :mailing2_city
      t.string :mailing2_zip
      t.string :home2_phone
      t.string :mother2_last
      t.string :mother2_first
      t.string :mother2_home_phone
      t.string :mother2_work_phone
      t.string :mother2_cell
      t.string :mother2_email
      t.string :mother2_email2
      t.string :father2_last
      t.string :father2_first
      t.string :father2_home_phone
      t.string :father2_work_phone
      t.string :father2_cell
      t.string :father2_email
      t.string :father2_email2
      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
