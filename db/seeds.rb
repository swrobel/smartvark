# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
all = Category.create(:name=>"All")
food = all.children.create(:name=>"Food/Drink", :clever_name => "Feed Me")
clothes = all.children.create(:name=>"Clothes", :clever_name => "Dress Me")
services = all.children.create(:name=>"Services", :clever_name => "Serve Me")
entertainment = all.children.create(:name=>"Entertainment", :clever_name => "Entertain Me")
health = all.children.create(:name=>"Health/Beauty", :clever_name => "Revitalize Me")
shopping = all.children.create(:name=>"Shopping", :clever_name => "Retail Me")
food.children.create(:name=>"Bagels")
food.children.create(:name=>"Bakeries")
food.children.create(:name=>"Bar Food")
food.children.create(:name=>"Caribbean")
food.children.create(:name=>"Chinese")
food.children.create(:name=>"Coffee & Tea")
food.children.create(:name=>"Delis")
food.children.create(:name=>"Diners")
food.children.create(:name=>"Donuts")
food.children.create(:name=>"Fast Food")
food.children.create(:name=>"French")
food.children.create(:name=>"German")
food.children.create(:name=>"Greek")
food.children.create(:name=>"Ice Cream & Froyo")
food.children.create(:name=>"Indian")
food.children.create(:name=>"Italian")
food.children.create(:name=>"Japanese")
food.children.create(:name=>"Korean")
food.children.create(:name=>"Latin American")
food.children.create(:name=>"Mexican")
food.children.create(:name=>"Middle Eastern")
food.children.create(:name=>"Pizza")
food.children.create(:name=>"Seafood")
food.children.create(:name=>"Smoothies")
food.children.create(:name=>"Southern")
food.children.create(:name=>"Steakhouses")
food.children.create(:name=>"Sushi")
food.children.create(:name=>"Thai")
food.children.create(:name=>"Vegetarian/Vegan")
food.children.create(:name=>"Wine/Drinks")
clothes.children.create(:name=>"Accessories")
clothes.children.create(:name=>"Baby")
clothes.children.create(:name=>"Boutique")
clothes.children.create(:name=>"Childrens")
clothes.children.create(:name=>"Formal")
clothes.children.create(:name=>"Jewelry")
clothes.children.create(:name=>"Mens")
clothes.children.create(:name=>"Shoes")
clothes.children.create(:name=>"Vintage")
clothes.children.create(:name=>"Womens")
services.children.create(:name=>"Appliance Repair")
services.children.create(:name=>"Automotive")
services.children.create(:name=>"Car Washes")
services.children.create(:name=>"Carpet Cleaning")
services.children.create(:name=>"Child Care & Day Care")
services.children.create(:name=>"Computer Repair")
services.children.create(:name=>"Dry Cleaning & Laundry")
services.children.create(:name=>"Home Cleaning")
services.children.create(:name=>"Home Repair")
services.children.create(:name=>"Landscaping")
services.children.create(:name=>"Movers")
services.children.create(:name=>"Pet Care")
entertainment.children.create(:name=>"Amusement Parks")
entertainment.children.create(:name=>"Bars & Clubs")
entertainment.children.create(:name=>"Festivals")
entertainment.children.create(:name=>"Movies")
entertainment.children.create(:name=>"Museums")
entertainment.children.create(:name=>"Sports")
health.children.create(:name=>"Beauty Supply")
health.children.create(:name=>"Dentists")
health.children.create(:name=>"Doctors")
health.children.create(:name=>"Fitness & Instruction")
health.children.create(:name=>"Hair Salons")
health.children.create(:name=>"Massage")
health.children.create(:name=>"Nail Salons")
health.children.create(:name=>"Piercing & Tattoo")
health.children.create(:name=>"Skin Care")
health.children.create(:name=>"Spas")
health.children.create(:name=>"Sports & Outdoors")
health.children.create(:name=>"Tanning")
health.children.create(:name=>"Vision")
health.children.create(:name=>"Yoga")
shopping.children.create(:name=>"Arts & Crafts")
shopping.children.create(:name=>"Baby Gear & Furniture")
shopping.children.create(:name=>"Books")
shopping.children.create(:name=>"Department Stores")
shopping.children.create(:name=>"Electronics")
shopping.children.create(:name=>"Flowers & Gifts")
shopping.children.create(:name=>"Garden")
shopping.children.create(:name=>"Home Funishings")
shopping.children.create(:name=>"Music")
shopping.children.create(:name=>"Pet Stores")
shopping.children.create(:name=>"Sporting Goods")
shopping.children.create(:name=>"Toys & Games")

%w(Coupon Deal Event).each { |name| OfferType.create(:name => name) }