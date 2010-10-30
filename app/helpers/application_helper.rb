# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def std_date(date)
    date ?  date.strftime('%m/%d/%y') : 'N/A'
  end

  def coupon_body(offer)
     "<span id='#{offer.id}_lead' class='subttl'>#{offer.lead}</span>
     <p id='#{offer.id}_diz'>#{offer.description}  Offer expires <span id='#{offer.id}_ed'>#{offer.expiry_datetime.try(:strftime,('%b. %d, %Y'))}<span></p>
     <div class='code'>
       <p id='#{offer.id}_rc'>#{offer.redemption_code}</p>
     </div>"
  end

  def deal_coupon(offer)
    link_to(
    "
    <strong class=\"c_#{offer.offer_type}\">#{offer.offer_type}</strong>
    <div class=""img_box"">
      " +
      image_tag(offer.coupon.url(:thumb)) +
    "
    </div>
    <span id='#{offer.id}_lead'>#{offer.lead}</span>
    ", viewdeal_url(offer.to_param),
              :onMouseOver => "$('offer_info_rollover').update('#{info_for_rollover(offer)}');",
              :onMouseOut => "$('offer_info_rollover').update('');"
             )
  end

  def coupon(offer)
    logo = current_user.logo.exists? ? image_tag(current_user.logo.url(:thumb)) : "Your Logo"
    "
    <div class='coupon'>
      <h4 id='#{offer.id}_type' class='c_#{offer.offer_type || "Coupon"}'>#{offer.offer_type || 'coupon'}</h4>
        <div class='holder'>
          <div class='center'>
            <div class='add-logo'>
            <a>#{logo}</a>
            </div>
          </div>
       </div>
       #{coupon_body offer}
     </div>
    "
  end

  def display_offer(offers, index, hidden=false)

    offer = offers[index]
    return if offer.nil?

    use_it_now_function = if logged_in?
      link_to("Use It Now", viewdeal_url(offer.to_param), {:class => "link"})
    else
      link_to_function("Use It Now", "jQuery('#signup-popup').modal();", {:class => "link"})
    end

"<li id='offer_#{offer.id}' #{"style='display:none'" if hidden} >"  +
  '<div class="frame">
    <div>' +
      deal_coupon(offer) +
    '</div>
  </div>
  <div class="rate">' +
    "<span onMouseOver=\"$('offer_info_rollover').update('"+ CGI.escapeHTML(info_for_rollover(offer))+ "');\"
           onMouseOut=\"$('offer_info_rollover').update('')\" >" +
    link_to_remote(image_tag('/images/btn-good.gif', :alt => "+"),
                   :url => { :action => "set_opinion", :offer_id => offer.id, :liked => 'true' }) +
    "</span>" + use_it_now_function +
    "<span onMouseOver=\"$('offer_info_rollover').update('"+ CGI.escapeHTML(info_for_rollover(offer))+ "');\"
           onMouseOut=\"$('offer_info_rollover').update('')\" >" +
    link_to_remote(image_tag('/images/btn-bad.gif', :alt => "+"),
                   :url => { :action => "set_opinion", :offer_id => offer.id, :liked => 'false' }) +
    "</span>" +
  '</div>
</li>'
  end
end
