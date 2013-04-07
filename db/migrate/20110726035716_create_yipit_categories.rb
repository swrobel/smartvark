class CreateYipitCategories < ActiveRecord::Migration
  def self.up
    seeds_path = File.expand_path("#{Rails.root}/db/seeds.rb")
    require(seeds_path)

    create_table :yipit_categories do |t|
      t.string :yipit_slug
      t.integer :category_id
      t.timestamps
    end
    Category.find('feed-me').yipit_categories.create(:yipit_slug => 'restaurants')
    Category.find('bars-clubs').yipit_categories.create(:yipit_slug => 'bar-club')
    Category.find('massage').yipit_categories.create(:yipit_slug => 'massage')
    Category.find('skin-care').yipit_categories.create(:yipit_slug => 'facial')
    Category.find('nail-salons').yipit_categories.create(:yipit_slug => 'manicure-pedicure')
    Category.find('tanning').yipit_categories.create(:yipit_slug => 'tanning')
    Category.find('hair-salons').yipit_categories.create(:yipit_slug => 'hair-salon')
    Category.find('revitalize-me').yipit_categories.create(:yipit_slug => 'hair-removal')
    Category.find('spas').yipit_categories.create(:yipit_slug => 'spa')
    Category.find('dentists').yipit_categories.create(:yipit_slug => 'teeth-whitening')
    Category.find('vision').yipit_categories.create(:yipit_slug => 'eye-vision')
    Category.find('beauty-supply').yipit_categories.create(:yipit_slug => 'makeup')
    Category.find('fitness-instruction').yipit_categories.create(:yipit_slug => 'pilates')
    Category.find('yoga').yipit_categories.create(:yipit_slug => 'yoga')
    Category.find('fitness-instruction').yipit_categories.create(:yipit_slug => 'gym')
    Category.find('fitness-instruction').yipit_categories.create(:yipit_slug => 'boot-camp')
    Category.find('mens').yipit_categories.create(:yipit_slug => 'mens-clothing')
    Category.find('womens').yipit_categories.create(:yipit_slug => 'womens-clothing')
    Category.find('feed-me').yipit_categories.create(:yipit_slug => 'food-grocery')
    Category.find('bakeries').yipit_categories.create(:yipit_slug => 'treats')
    Category.find('home-repair').yipit_categories.create(:yipit_slug => 'home-services')
    Category.find('museums').yipit_categories.create(:yipit_slug => 'museums')
    Category.find('winedrinks').yipit_categories.create(:yipit_slug => 'wine-tasting')
    Category.find('entertain-me').yipit_categories.create(:yipit_slug => 'city-tours')
    Category.find('entertain-me').yipit_categories.create(:yipit_slug => 'comedy-clubs')
    Category.find('entertain-me').yipit_categories.create(:yipit_slug => 'theater')
    Category.find('entertain-me').yipit_categories.create(:yipit_slug => 'concerts')
    Category.find('revitalize-me').yipit_categories.create(:yipit_slug => 'life-skills-classes')
    Category.find('sports').yipit_categories.create(:yipit_slug => 'golf')
    Category.find('sports').yipit_categories.create(:yipit_slug => 'bowling')
    Category.find('sports').yipit_categories.create(:yipit_slug => 'sporting-events')
    Category.find('sports').yipit_categories.create(:yipit_slug => 'skydiving')
    Category.find('sports').yipit_categories.create(:yipit_slug => 'skiing')
    Category.find('entertain-me').yipit_categories.create(:yipit_slug => 'dance-classes')
    Category.find('baby').yipit_categories.create(:yipit_slug => 'baby')
    Category.find('childrens').yipit_categories.create(:yipit_slug => 'kids')
    Category.find('dress-me').yipit_categories.create(:yipit_slug => 'college')
    Category.find('dress-me').yipit_categories.create(:yipit_slug => 'bridal')
    Category.find('pet-stores').yipit_categories.create(:yipit_slug => 'pets')
    Category.find('entertain-me').yipit_categories.create(:yipit_slug => 'travel')
    Category.find('dentists').yipit_categories.create(:yipit_slug => 'dental')
    Category.find('revitalize-me').yipit_categories.create(:yipit_slug => 'chiropractic')
    Category.find('skin-care').yipit_categories.create(:yipit_slug => 'dermatology')
    Category.find('fitness-instruction').yipit_categories.create(:yipit_slug => 'martial-arts')
    Category.find('fitness-instruction').yipit_categories.create(:yipit_slug => 'fitness-classes')
    Category.find('fitness-instruction').yipit_categories.create(:yipit_slug => 'personal-training')
    Category.find('entertain-me').yipit_categories.create(:yipit_slug => 'photography-services')
    Category.find('automotive').yipit_categories.create(:yipit_slug => 'automotive-services')
    Category.find('sports').yipit_categories.create(:yipit_slug => 'outdoor-adventures')
    Category.find('entertain-me').yipit_categories.create(:yipit_slug => 'gay')
    Category.find('entertain-me').yipit_categories.create(:yipit_slug => 'jewish')
  end

  def self.down
    drop_table :yipit_categories
  end
end
