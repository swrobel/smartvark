class Import < ActiveRecord::Base
  serialize :errors

  has_many :yipit_rows

  def from_yipit
    user = User.find_by_email("api@yipit.com")
    offer_type_id = OfferType.find_by_name("Coupon").id
    begin
      result = Net::HTTP.get URI.parse('http://api.yipit.com/v1/deals/?key=tFkn69TXrYFuHZgC&division=los-angeles&limit=5000&paid=1')
      data = Yajl::Parser.parse(result)
    rescue Exception => ex
      this.errors = ex
      return
    end
    this.source_rows = data["response"]["deals"].count
    this.success_rows = 0
    data["response"]["deals"].each { |deal|
      biz = deal["business"]
      business_ids = []
      errors = []
      created_biz = false

      biz["locations"].each { |loc|
        begin
          business = Business.find_by_yipit_id(loc["id"])
          unless business
            business = user.businesses.create!(yipit_id: loc["id"], name: biz["name"], address: loc["address"], city: loc["smart_locality"], state: loc["state"], zipcode: loc["zip_code"], phone: loc["phone"], website: biz["url"])
            created_biz = true
          end
          business_ids << business.id
        rescue Exception => ex
          errors << ex
        end
      }
      begin
        offer = Offer.find_by_yipit_id(deal["id"])
        created_offer = false
        unless offer
          category_id = YipitCategory.find_by_yipit_slug(deal["tags"].first["slug"]).category_id
          offer = user.offers.create!(yipit_id: deal["id"], offer_type_id: offer_type_id, category_id: category_id, business_ids: business_ids, title: deal["yipit_title"], description: deal["title"], start_date: deal["date_added"], end_date: deal["end_date"], redemption_link: deal["url"], source: deal["source"]["name"], image_url_big: deal["images"]["image_big"], image_url_small: deal["images"]["image_small"])
          created_offer = true
        end
        this.success_rows += 1
      rescue Exception => ex
        errors << ex
      ensure
        this.yipit_rows.create(yipit_id: deal["id"], offer_id: offer.id, created_offer: created_offer, created_biz: created_biz, data: deal, errors: errors)
      end
    }
  end
end
