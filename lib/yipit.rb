module Yipit
  def self.get_deals
    user = User.find_by_email("api@yipit.com")
    offer_type_id = OfferType.find_by_name("Coupon").id
    result = Net::HTTP.get URI.parse('http://api.yipit.com/v1/deals/?key=tFkn69TXrYFuHZgC&division=los-angeles&limit=5000&paid=1')
    data = Yajl::Parser.parse(result)
    data["response"]["deals"].each { |deal|
      biz = deal["business"]
      business_ids = []
      biz["locations"].each { |loc|
        business = Business.find_by_yipit_id(loc["id"])
        business = user.businesses.create(yipit_id: loc["id"], name: biz["name"], address: loc["address"], city: loc["smart_locality"], state: loc["state"], zipcode: loc["zip_code"], phone: loc["phone"], website: biz["url"]) unless business
        business_ids << business.id
      }
      offer = Offer.find_by_yipit_id(deal["id"])
      unless offer
        category_id = YipitCategory.find_by_yipit_slug(deal["tags"].first["slug"]).category_id
        offer = user.offers.create(yipit_id: deal["id"], offer_type_id: offer_type_id, category_id: category_id, business_ids: business_ids, title: deal["yipit_title"], description: deal["title"], start_date: deal["date_added"], end_date: deal["end_date"], redemption_link: deal["url"], source: deal["source"]["name"], image_url_big: deal["images"]["image_big"], image_url_small: deal["images"]["image_small"])
      end
    }
  end
end