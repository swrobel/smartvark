class Import < ActiveRecord::Base
  serialize :import_errors

  has_many :yipit_rows
  has_many :sqoot_rows

  def from_sqoot(location = "Los Angeles", radius = 40)
    user = User.find_by_email("api@sqoot.com")
    offer_type_id = OfferType.find_by_name("Coupon").id
    endpoint = "http://api.sqoot.com/v1/offers?affiliate_token=cz17bb&location=#{location}&radius=#{radius}&order=expires_at&per_page=250&providers_not=Restaurant.com,GrubHub,Goldstar,SeatGeek,Half Off Depot,Your Best Deals,Mobile Spinach,LiveOpenly,jdeal"
    self.import_errors = []
    self.success_rows = 0
    begin

      # Pull all pages from Sqoot
      begin
        offers = []
        page = 0
        begin
          page += 1
          data = URI.escape(endpoint + "&page=#{page}").to_uri.get.deserialize
          self.source_rows = data["total"]
          offers += data["offers"]
        end until page * 250 >= self.source_rows
      rescue => ex
        self.import_errors << {message: ex.message, backtrace: ex.backtrace}
      end

      # Process Sqoot data
      offers.each { |deal|
        begin
          deal = deal["offer"]
          biz = deal["merchant_name"]
          business_ids = []
          row_errors = []
          created_biz = false
          created_offer = false

          if deal["categories"].blank?
            row_errors << {message: "No categories for offer"}
          else
            category_id = nil
            deal["categories"].each { |cat|
              category_id = SqootCategory.find_by_slug(cat).try(:category_id)
              break if category_id
            }

            if category_id.blank?
              row_errors << {message: "No matching Sqoot categories"}
            else
              start_date = Date.today
              img_small = deal["image"].try(:slice, 10)
              img_big = deal["image"].try(:slice, 11)
              img_big ||= img_small

              offer = Offer.find_by_sqoot_id(deal["id"])

              if offer
                offer.update_attributes(category_id: category_id, title: deal["short_title"], description: deal["description"], start_date: start_date, end_date: deal["expires_at"], redemption_link: deal["url"], source: deal["source"], image_url_big: img_big, image_url_small: img_small, commission: deal["commission"], num_sold: deal["number_sold"])
              else
                deal["locations"].each { |loc|
                  begin
                    business = Business.find_by_phone(Phoner::Phone.parse(loc["phone_number"]).to_s)
                    unless business
                      name = loc["name"] || biz
                      business = user.businesses.create!(name: name, address: loc["street_address_1"], city: loc["city"], state: loc["state"], zipcode: loc["zip"], latitude: loc["latitude"], longitude: loc["longitude"], phone: loc["phone_number"], website: loc["url"])
                      created_biz = true
                    end
                    business_ids << business.id
                  rescue => ex
                    row_errors << {message: ex.message, backtrace: ex.backtrace}
                  end
                } unless deal["locations"].blank?

                if business_ids.blank?
                  row_errors << {message: "No businesses for offer"}
                else
                  offer = user.offers.create!(sqoot_id: deal["id"], offer_type_id: offer_type_id, category_id: category_id, business_ids: business_ids.uniq, title: deal["short_title"], description: deal["description"], start_date: start_date, end_date: deal["expires_at"], redemption_link: deal["url"], source: deal["source"], image_url_big: img_big, image_url_small: img_small, commission: deal["commission"], num_sold: deal["number_sold"])
                  created_offer = true
                end              
              end
            end
          end
          self.success_rows += 1 if offer
        rescue => ex
          row_errors << {message: ex.message, backtrace: ex.backtrace}
        ensure
          offer_id = offer.nil? ? nil : offer.id
          row_errors = nil if row_errors.blank?
          self.sqoot_rows.create(sqoot_id: deal["id"], offer_id: offer_id, created_offer: created_offer, created_biz: created_biz, row_data: deal, row_errors: row_errors)
        end
      }
    rescue => ex
      self.import_errors << {message: ex.message, backtrace: ex.backtrace}
      return false
    end
    self.import_errors = nil if self.import_errors.blank?
    return true
  end

  def from_yipit(division = "los-angeles")
    user = User.find_by_email("api@yipit.com")
    offer_type_id = OfferType.find_by_name("Coupon").id
    begin
      result = Net::HTTP.get URI.parse("http://api.yipit.com/v1/deals/?key=tFkn69TXrYFuHZgC&division=#{division}&limit=5000")
      data = Yajl::Parser.parse(result)
    rescue Exception => ex
      self.import_errors = ex
      return false
    end
    self.source_rows = data["response"]["deals"].count
    self.success_rows = 0
    data["response"]["deals"].each { |deal|
      biz = deal["business"]
      business_ids = []
      row_errors = []
      created_biz = false

      row_errors << "No locations for business" if biz["locations"].blank?

      biz["locations"].each { |loc|
        begin
          business = Business.find_by_yipit_id(loc["id"])
          unless business
            business = user.businesses.create!(yipit_id: loc["id"], name: biz["name"], address: loc["address"], city: loc["smart_locality"], state: loc["state"], zipcode: loc["zip_code"], phone: loc["phone"], website: biz["url"])
            created_biz = true
          end
          business_ids << business.id
        rescue Exception => ex
          row_errors << ex
        end
      }
      begin
        offer = Offer.find_by_yipit_id(deal["id"])
        created_offer = false
        unless offer || business_ids.blank?
          if deal["tags"].blank?
            row_errors << "No categories for offer"
          else
            category_id = YipitCategory.find_by_yipit_slug(deal["tags"].first["slug"]).category_id
            start_date = Time.zone.parse(deal["date_added"] + " UTC").to_date
            end_date = Time.zone.parse(deal["end_date"] + " UTC").to_date
            offer = user.offers.create!(yipit_id: deal["id"], offer_type_id: offer_type_id, category_id: category_id, business_ids: business_ids, title: deal["yipit_title"], description: deal["title"], start_date: start_date, end_date: end_date, redemption_link: deal["url"], source: deal["source"]["name"], image_url_big: deal["images"]["image_big"], image_url_small: deal["images"]["image_small"])
            created_offer = true
          end
        end
        self.success_rows += 1 if offer
      rescue Exception => ex
        row_errors << ex
      ensure
        offer_id = offer.nil? ? nil : offer.id
        row_errors = nil if row_errors.blank?
        self.yipit_rows.create(yipit_id: deal["id"], offer_id: offer_id, created_offer: created_offer, created_biz: created_biz, row_data: deal, row_errors: row_errors)
      end
    }
    return true
  end
end