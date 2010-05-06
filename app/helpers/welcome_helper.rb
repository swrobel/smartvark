module WelcomeHelper

  def categories
    @categories ||=Category.all
  end

  def categories_count
    @categories_count ||= categories.length
  end

  def link_class(index)
    if index.zero?
      'first'
    elsif index == categories_count-1
      'last'
    end
  end

  def li_class(index, category_id=nil)
    'active' if index+1 == (category_id || 1).to_i
  end

  def info_for_rollover(offer)
    "<strong class=\"title\">#{offer.business.name}:</strong><p>#{offer.lead}, expires #{std_date(offer.expiry_datetime)}.</p><p>To redeem online, use code #{offer.redemption_code} or send to your phone.</p><p>#{offer.exclusivity_text}</p>".gsub(/'/,"\\\'")
  end

  def display_offer(offers, index, hidden=false)

    offer = offers[index]
    return if offer.nil?
"<li id='offer_#{offer.id}' #{"style='display:none'" if hidden} >"  +
  '<div class="frame">
    <div>' +
      link_to(image_tag(offer.coupon.url, :width => 175, :height => 100), viewdeal_url(offer.to_param),
              :onMouseOver => "$('offer_info_rollover').update('#{info_for_rollover(offer)}');"
             )+
    '</div>
  </div>
  <div class="rate">' +
    link_to_remote(image_tag('/images/btn-good.gif', :alt => "+"),
                   :url => { :action => "set_opinion", :offer_id => offer.id, :liked => 'true' }) +
    link_to_remote(image_tag('/images/btn-bad.gif', :alt => "+"),
                   :url => { :action => "set_opinion", :offer_id => offer.id, :liked => 'false' }) +
  '</div>
</li>'
  end

  def list_offer(offer)
    "<li id='offer_#{offer.id}'>" +
    hidden_field_tag("user[offer_ids][]", offer.id) +
    link_to("<h3>#{offer.lead}</h3>", offer) +
      "<p>#{offer.exclusivity_text}</p>" +
      "<p>Expiration: #{offer.expiry_datetime.strftime('%B %d, %Y')}</p></li>"
  end
end
