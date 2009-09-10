class AddEntrycode < ActiveRecord::Migration
  def self.up
    add_column :students, :entrycode, :string, :limit => 10
  end

  def self.down
    remove_column :students, :entrycode
  end
end
