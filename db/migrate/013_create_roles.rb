class CreateRoles < ActiveRecord::Migration
  def self.up
    schoolwire_roles = {
      106 => 'Teacher',
      107 => 'Parent',
      108 => 'Student',
      109 => 'Staff',
      110 => 'Administrator',
      111 => 'Parent-Bacich',
      112 => 'Parent-Kent',
      113 => 'Trustee',
      114 => 'PTA Board Member',
      115 => 'Teacher-Bacich',
      116 => 'Teacher-Kent',
      117 => 'Staff-Bacich',
      118 => 'Staff-Kent',
      119 => 'Community',
      120 => 'Parent-Kindergarten',
      121 => 'Parent-1st Grade',
      122 => 'Parent-2nd Grade',
      123 => 'Parent-3rd Grade',
      124 => 'Parent-4th Grade',
      125 => 'Parent-5th Grade',
      126 => 'Parent-6th Grade',
      127 => 'Parent-7th Grade',
      128 => 'Parent-8th Grade',
      129 => 'KSF Administration',
      130 => 'Parent Contributor',
      131 => 'Library Administrator',
    }
    
    create_table :roles, :id => false, :force => true do |t|
      t.integer  :id, :null => false, :default => 0
      t.string   :name, :null => false
      t.timestamps
    end
    
    add_index('roles', 'id', :unique => true)    
    
    schoolwire_roles.each do |k, v|
      r = Role.new
      r.id = k
      r.name = v
      r.save
    end
  end

  def self.down
    drop_table :roles
  end
end
