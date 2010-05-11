# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

%w(All Food Clothes Services Entertainment Beauty/Spa).each do |name|
  Category.find_or_create_by_name(name)
end

Offer.all.each { |x| x.destroy }
['DSW Shoes,,Clothes,,30% off on everything,Valid at any location in Southern California,,5/21/2010',
'El Pollo Loco,,Food,,Buy One Get One Free,Good at Westwood location only,1675,6/30/2010',
'Friendlys,,Food,,Free Ice Cream Sundae,,,5/31/2010',
'Gamestop,,Entertainment,,25% off any used game,,,6/30/2010',
'Jamba Juice,,Food,,Buy One Get One Free,Valid at participating locations,,6/1/2010',
'Moondance,,Clothes,,20% OFF all silver jewelry,Good at Montana Ave. location only,,8/11/2010',
'Quizno\'s,,Food,,$5 Toasty Torpedo combo,,5305,8/16/2010',
'Sports Authority,,Clothes,,$25 off $100,Valid at any location in Southern California,TSA8977,6/11/2010',
'Toys R Us,,Entertainment,,$5 off your purchase,Valid at participating locations,,5/15/2010',
'Uncle Sam\'s Quick Lube,,Services,,$7 off your Next Oil Change,Offer not valid with any other offers.,,6/18/2010'].each do|x|
arr = x.split(/,/)
m,d,y = arr.last.split('/')

 offer = Offer.create({
 :lead => arr[4].strip,
 :category => Category.find_or_create_by_name(arr[2].strip),
 :business => Business.find_or_create_by_name(arr[0].strip),
 :description => arr[5],
 :redemption_code => arr[6],
 :expiry_datetime => DateTime.civil(y.to_i,m.to_i,d.to_i)
 })
end

pw = 'password'
%w(username@smartvark.com ted.price@gmail.com swrobel@smartvark.com).each do |login|
  hsh = {
    :login => login,
    :email => login,
    :password => pw,
    :password_confirmation => pw,
  }
  u=User.new(hsh)
  unless u.save
    u.errors.each_full { |x| puts x }
  end
end

Business.all.each do |business|
  next if business.postal_code
  business.update_attributes({
    :street_address_1 => "#{business.id*200} Wilshire Blvd.",
    :city => 'Santa Monica',
    :state => 'CA',
    :postal_code => '90401'
  })
end
