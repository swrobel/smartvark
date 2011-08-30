class CreateSqootCategories < ActiveRecord::Migration
  def self.up
    create_table :sqoot_categories do |t|
      t.string :name
      t.integer :category_id

      t.timestamps
    end
    Category.find('entertain-me').sqoot_categories.create(name: 'Active')
    Category.find('revitalize-me').sqoot_categories.create(name: 'Beauty')
    Category.find('entertain-me').sqoot_categories.create(name: 'Entertainment')
    Category.find('dress-me').sqoot_categories.create(name: 'Fashion')
    Category.find('revitalize-me').sqoot_categories.create(name: 'Fitness')
    Category.find('entertain-me').sqoot_categories.create(name: 'Nightlife')
    Category.find('feed-me').sqoot_categories.create(name: 'Restaurants')
    Category.find('entertain-me').sqoot_categories.create(name: 'Sports')
    Category.find('entertain-me').sqoot_categories.create(name: 'Travel')
  end

  def self.down
    drop_table :sqoot_categories
  end
end
