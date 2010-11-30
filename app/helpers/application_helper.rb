# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def std_date(date)
    date ?  date.strftime('%m/%d/%y') : 'N/A'
  end
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def head_additions(elements)
    content_for(:head_additions) { elements + "\n" }
  end

  def coupon_body(offer)
     "<span id='#{offer.id}_lead' class='subttl'>#{offer.lead}</span>
     <p id='#{offer.id}_diz'>#{offer.description}  Offer expires <span id='#{offer.id}_ed'>#{offer.expiry_datetime.try(:strftime,('%b. %d, %Y'))}</span></p>
     <div class='code'>
       <p id='#{offer.id}_rc'>#{offer.redemption_code}</p>
     </div>"
  end

  def deal_coupon(offer)
    link_to(
    "
    <strong class=\"c_#{offer.offer_type}\">#{offer.offer_type}</strong>
    <div class=""img_box"">
      #{image_tag(offer.coupon.url(:thumb))}
    </div>
    <span id='#{offer.id}_lead'>#{offer.lead}</span>".html_safe,
    viewdeal_url(offer.to_param))
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

  def use_it_now_link offer
    if logged_in?
      link_to("Use It Now", viewdeal_url(offer.to_param), {:class => "link"})
    else
      link_to_function("Use It Now", "jQuery('#signup-popup').modal();", {:class => "link"})
    end
  end

  def display_offer(offers, index, hidden=false)

    offer = offers[index]
    return if offer.nil?

"<li id='offer_#{offer.id}' #{"style='display:none;'" if hidden} onmouseover=\"jQuery('#offer_info_rollover').html('"+ h(info_for_rollover(offer))+ "');\"
           onmouseout=\"jQuery('#offer_info_rollover').empty()\" >"  +
  '<div class="frame">
    <div>' +
      deal_coupon(offer) +
    '</div>
  </div>
  <div class="rate">' +
    link_to(image_tag('/images/btn-good.gif', :alt => "+"),
                   { :controller => "welcome", :action => "set_opinion", :offer_id => offer.id, :liked => true }, :remote => true) +
    use_it_now_link(offer) +
    link_to(image_tag('/images/btn-bad.gif', :alt => "-"),
                   { :controller => "welcome", :action => "set_opinion", :offer_id => offer.id, :liked => false }, :remote => true) +
  '</div>
</li>'
  end
end
