class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events, :force => true do |t|
      t.integer :version_id, :null => false
      t.integer :diff_version_id
      t.string  :event_type, :null => false
      t.string  :description, :null => false
      t.string  :record_summary
      t.string  :table_row_type
      t.integer :table_row_id
      t.string  :table_column
      t.string  :table_row_value
      t.string  :corrected_value
      t.string  :related_row_type
      t.integer :related_row_id
      t.string  :related_column
      t.string  :related_row_value
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
