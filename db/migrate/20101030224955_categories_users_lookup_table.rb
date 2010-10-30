class CategoriesUsersLookupTable < ActiveRecord::Migration
  def self.up
    create_table :categories_users, :id => false do |t|
      t.integer :category_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :categories_users
  end
end
