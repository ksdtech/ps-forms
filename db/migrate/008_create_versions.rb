class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions, :force => true do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :versions
  end
end
