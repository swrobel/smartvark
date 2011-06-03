class ChangeUserDefaultRoleToUser < ActiveRecord::Migration
  def self.up
    change_column_default :users, :role, "user"
  end

  def self.down
    change_column_default :users, :role, "pending"
  end
end
