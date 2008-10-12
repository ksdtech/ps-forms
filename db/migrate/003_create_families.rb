class CreateFamilies < ActiveRecord::Migration
  def self.up
    create_table :families, :force => true do |t|
      t.integer :version_id, :null => false, :default => 0
      t.integer :home_id, :null => false, :default => 0
      t.string  :last_name
      t.string  :powerschool_password
      t.string  :street
      t.string  :state
      t.string  :city
      t.string  :zip
      t.string  :mailing_street
      t.string  :mailing_state
      t.string  :mailing_city
      t.string  :mailing_zip
      t.string  :home_phone
      t.timestamps
    end
  end

  def self.down
    drop_table :families
  end
end
