class ConvertUsersToDevise < ActiveRecord::Migration
  def self.up
    # Remove Authlogic_Connect stuff
    drop_table :access_tokens
    remove_index :users, :active_token_id
    remove_column :users, :active_token_id
     
    change_table :users do |t|
    # Remove Authlogic stuff
      t.remove :login
      t.remove :failed_login_count
      t.remove :last_request_at
      t.remove :persistence_token
      t.remove :single_access_token
      t.remove :perishable_token
      
    # Add Devise stuff
      t.change :email, :string, :null => false, :default => ""
      t.change :crypted_password, :string, :null => false, :default => "", :limit => 128
      t.rename :crypted_password, :encrypted_password
      t.rename :current_login_at, :current_sign_in_at
      t.rename :last_login_at, :last_sign_in_at
      t.rename :current_login_ip, :current_sign_in_ip
      t.rename :last_login_ip, :last_sign_in_ip
      t.rename :login_count, :sign_in_count
      t.recoverable
      t.rememberable
      
      t.index :email, :unique => true
      t.index :reset_password_token, :unique => true
    end
  end

  def self.down
    change_table :users do |t|
    # Remove Devise stuff
      t.remove_index :reset_password_token
      t.remove :reset_password_token
      t.remove :remember_token
      t.remove :remember_created_at
      
    # Add back Authlogic stuff
      t.string    :login,               :null => false                # optional, you can use email instead, or both
      t.string    :persistence_token,   :null => false                # required
      t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.timestamps
      t.change :email, :string, :null => true
      t.change :crypted_password, :string, :null => true
      t.rename :encrypted_password, :crypted_password
      t.rename :current_sign_in_at, :current_login_at
      t.rename :last_sign_in_at, :last_login_at
      t.rename :current_sign_in_ip, :current_login_ip
      t.rename :last_sign_in_ip, :last_login_ip
      t.rename :sign_in_count, :login_count
    end
    
    # Add back Authlogic_Connect stuff
    create_table :access_tokens do |t|
      t.integer :user_id
      t.string :type, :limit => 30
      t.string :key # how we identify the user, in case they logout and log back in
      t.string :token, :limit => 1024 # This has to be huge because of Yahoo's excessively large tokens
      t.string :secret
      t.boolean :active # whether or not it's associated with the account
      t.timestamps
    end 
    add_index :access_tokens, :key, :unique => true
    
    add_column :users, :active_token_id, :integer
    add_index :users, :active_token_id    
  end
end
