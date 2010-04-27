class CreateUserAudits < ActiveRecord::Migration
  def self.up
    create_table :user_audits do |t|
      t.integer :user_id
      t.string :request, :limit => 3000

      t.timestamps
    end
  end

  def self.down
    drop_table :user_audits
  end
end
