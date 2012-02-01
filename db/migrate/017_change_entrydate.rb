class ChangeEntrydate < ActiveRecord::Migration
  def self.up
    change_column :students, :entrydate, :date
  end

  def self.down
    change_column :students, :entrydate, :string, :limit => 10
  end
end
