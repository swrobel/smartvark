class CreateSqootCategories < ActiveRecord::Migration
  def self.up
    create_table :sqoot_categories do |t|
      t.string :name
      t.string :slug
      t.integer :category_id

      t.timestamps
    end

    add_index :sqoot_categories, :category_id
    add_index :sqoot_categories, :slug

    Category.find('entertain-me').sqoot_categories.create!(name: "Activities & Events", slug: 'activities-events')
    Category.find('sports-outdoors').sqoot_categories.create!(name: "Bowling", slug: 'bowling')
    Category.find('entertain-me').sqoot_categories.create!(name: "City Tours", slug: 'city-tours')
    Category.find('comedy').sqoot_categories.create!(name: "Comedy Clubs", slug: 'comedy-clubs')
    Category.find('concerts').sqoot_categories.create!(name: "Concerts", slug: 'concerts')
    Category.find('dancing').sqoot_categories.create!(name: "Dance Classes", slug: 'dance-classes')
    Category.find('sports-outdoors').sqoot_categories.create!(name: "Golf", slug: 'golf')
    Category.find('classes').sqoot_categories.create!(name: "Life Skills Classes", slug: 'life-skills-classes')
    Category.find('museums').sqoot_categories.create!(name: "Museums", slug: 'museums')
    Category.find('sports-outdoors').sqoot_categories.create!(name: "Outdoor Adventures", slug: 'outdoor-adventures')
    Category.find('sports-outdoors').sqoot_categories.create!(name: "Skiing", slug: 'skiing')
    Category.find('sports-outdoors').sqoot_categories.create!(name: "Skydiving", slug: 'skydiving')
    Category.find('sports').sqoot_categories.create!(name: "Sporting Events", slug: 'sporting-events')
    Category.find('theater').sqoot_categories.create!(name: "Theater", slug: 'theater')
    Category.find('bars-clubs').sqoot_categories.create!(name: "Wine Tasting", slug: 'wine-tasting')
    Category.find('feed-me').sqoot_categories.create!(name: "Dining & Nightlife", slug: 'dining-nightlife')
    Category.find('bars-clubs').sqoot_categories.create!(name: "Bars & Clubs", slug: 'bars-clubs')
    Category.find('feed-me').sqoot_categories.create!(name: "Restaurants", slug: 'restaurants')
    Category.find('fitness-instruction').sqoot_categories.create!(name: "Fitness", slug: 'fitness')
    Category.find('fitness-instruction').sqoot_categories.create!(name: "Boot Camp", slug: 'boot-camp')
    Category.find('fitness-instruction').sqoot_categories.create!(name: "Fitness Classes", slug: 'fitness-classes')
    Category.find('gyms').sqoot_categories.create!(name: "Gym", slug: 'gym')
    Category.find('fitness-instruction').sqoot_categories.create!(name: "Martial Arts", slug: 'martial-arts')
    Category.find('fitness-instruction').sqoot_categories.create!(name: "Personal Training", slug: 'personal-training')
    Category.find('pilates').sqoot_categories.create!(name: "Pilates", slug: 'pilates')
    Category.find('yoga').sqoot_categories.create!(name: "Yoga", slug: 'yoga')
    Category.find('revitalize-me').sqoot_categories.create!(name: "Health & Beauty", slug: 'health-beauty')
    Category.find('massage').sqoot_categories.create!(name: "Chiropractic", slug: 'chiropractic')
    Category.find('dentists').sqoot_categories.create!(name: "Dental", slug: 'dental')
    Category.find('doctors').sqoot_categories.create!(name: "Dermatology", slug: 'dermatology')
    Category.find('vision').sqoot_categories.create!(name: "Eye & Vision", slug: 'eye-vision')
    Category.find('skin-care').sqoot_categories.create!(name: "Facial", slug: 'facial')
    Category.find('hair-salons').sqoot_categories.create!(name: "Hair Removal", slug: 'hair-removal')
    Category.find('hair-salons').sqoot_categories.create!(name: "Hair Salon", slug: 'hair-salon')
    Category.find('beauty-supply').sqoot_categories.create!(name: "Makeup", slug: 'makeup')
    Category.find('nail-salons').sqoot_categories.create!(name: "Manicure & Pedicure", slug: 'manicure-pedicure')
    Category.find('massage').sqoot_categories.create!(name: "Massage", slug: 'massage')
    Category.find('spas').sqoot_categories.create!(name: "Spa", slug: 'spa')
    Category.find('tanning').sqoot_categories.create!(name: "Tanning", slug: 'tanning')
    Category.find('dentists').sqoot_categories.create!(name: "Teeth Whitening", slug: 'teeth-whitening')
    SqootCategory.create!(name: "Retail & Services", slug: 'retail-services')
    Category.find('automotive').sqoot_categories.create!(name: "Automotive Services", slug: 'automotive-services')
    Category.find('feed-me').sqoot_categories.create!(name: "Food & Grocery", slug: 'food-grocery')
    Category.find('home-cleaning').sqoot_categories.create!(name: "Home Services", slug: 'home-services')
    Category.find('mens').sqoot_categories.create!(name: "Men's Clothing", slug: 'mens-clothing')
    Category.find('photography').sqoot_categories.create!(name: "Photography Services", slug: 'photography-services')
    Category.find('ice-cream-froyo').sqoot_categories.create!(name: "Treats", slug: 'treats')
    Category.find('womens').sqoot_categories.create!(name: "Women's Clothing", slug: 'womens-clothing')
    Category.find('retail-me').sqoot_categories.create!(name: "Special Interest", slug: 'special-interest')
    Category.find('baby').sqoot_categories.create!(name: "Baby", slug: 'baby')
    Category.find('womens').sqoot_categories.create!(name: "Bridal", slug: 'bridal')
    Category.find('retail-me').sqoot_categories.create!(name: "College", slug: 'college')
    SqootCategory.create!(name: "Gay", slug: 'gay')
    SqootCategory.create!(name: "Jewish", slug: 'jewish')
    Category.find('family').sqoot_categories.create!(name: "Kids", slug: 'kids')
    SqootCategory.create!(name: "Kosher", slug: 'kosher')
    Category.find('pet-care').sqoot_categories.create!(name: "Pets", slug: 'pets')
    Category.find('travel').sqoot_categories.create!(name: "Travel", slug: 'travel')
  end

  def self.down
    drop_table :sqoot_categories
  end
end
