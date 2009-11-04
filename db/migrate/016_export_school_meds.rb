class ExportSchoolMeds < ActiveRecord::Migration
  def self.up
    add_column :students, :school_meds_office, :boolean
    add_column :students, :school_meds_backpack, :boolean
    remove_column :students, :school_meds_complete 
  end

  def self.down
    add_column :students, :school_meds_complete, :boolean 
    remove_column :students, :school_meds_office
    remove_column :students, :school_meds_backpack
  end
end
