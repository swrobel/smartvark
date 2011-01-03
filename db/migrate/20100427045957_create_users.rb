class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.database_authenticatable
      t.string :name, :limit => 100
      t.string :address, :limit => 100
      t.string :city, :limit => 50
      t.string :state, :limit => 2
      t.string :zipcode, :limit => 10
      t.string :phone, :limit => 12
      t.string :gender, :limit => 1
      t.date :birthday
      t.string :role, :default => "user"
      t.integer :category_id
      t.rememberable
      t.trackable
      t.recoverable
      t.timestamps
    end
    
    add_index :users, :email, :unique => true
    add_index :users, :reset_password_token, :unique => true 
  end

  def self.down
    drop_table :users
  end
end
