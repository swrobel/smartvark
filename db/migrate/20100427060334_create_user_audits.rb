class CreateUserAudits < ActiveRecord::Migration
  def self.up
    create_table :user_audits do |t|
      t.integer :user_id
      t.string :controller
      t.string :action
      t.string :request, :limit => 3000

      t.timestamps
    end
    
    add_index :user_audits, :user_id
    add_index :user_audits, [:controller, :action]
    add_index :user_audits, :action
  end

  def self.down
    drop_table :user_audits
  end
end
