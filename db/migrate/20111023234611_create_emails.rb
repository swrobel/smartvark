class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.integer :user_id

      t.timestamps
    end

    add_index :emails, :user_id
  end

  def self.down
    drop_table :emails
  end
end
