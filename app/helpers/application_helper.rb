# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def std_date(date)
    date ?  date.strftime('%m/%d/%y') : 'N/A'
  end

  def coupon_body(offer)
     "<span id='#{offer.id}_title' class='subttl'>#{offer.title}</span>
     <p id='#{offer.id}_fine_print'>#{offer.fine_print}</p>
     <p>Offer expires <span id='#{offer.id}_end_date'>#{offer.end_date.try(:strftime,('%b %d, %Y'))}</span></p>
     <div class='code'>
       <p id='#{offer.id}_rc'>#{offer.redemption_code}</p>
     </div>"
  end

  def deal_coupon(offer)
    logo = "missing logo"
    if offer.image_url_small
      logo = image_tag(offer.image_url_small)
    elsif offer.user
      if offer.logo.file?
        logo = image_tag(offer.logo.url(:thumb))
      else
        logo = "<p><strong>#{offer.user.name}</strong></p>"
      end
    end
    link_to(
    "<strong class='c_#{offer.offer_type.name}'><img class='left' src='/images/#{offer.category.parent_or_friendly_id}-white.png'/>#{offer.offer_type.name}<img class='right' src='/images/#{offer.category.parent_or_friendly_id}-white.png'/></strong>
    <div class='img_box'>
      #{logo}
    </div>
    <span id='#{offer.id}_title'>#{offer.title}</span>".html_safe,
    viewdeal_path(offer))
  end
  
  def mobile_coupon(offer)
    logo = "missing logo"
    if offer.image_url_small
      logo = image_tag(offer.image_url_small)
    elsif offer.user
      if offer.logo.file?
        logo = image_tag(offer.logo.url(:thumb))
      else
        logo = "<p><strong>#{offer.user.name}</strong></p>"
      end
    end
    type_name = offer.offer_type.name if offer.offer_type
    "
    <div class='coupon'>
      <h4 class='c_#{type_name || "Coupon"}'><img class='left' src='/images/#{offer.category.parent_or_friendly_id}-white.png'/>#{type_name || 'coupon'}<img class='right' src='/images/#{offer.category.parent_or_friendly_id}-white.png'/></h4>
        <div class='holder'>
          <div class='center'>
            <div class='add-logo'>
              #{logo}
            </div>
          </div>
       </div>
       <span class='subttl'>#{offer.title}</span>
        <p>#{auto_link(offer.description, :html => { :target => '_blank' }).try(:html_safe)}</p>
     </div>
    "
  end

  def coupon(offer)
    logo = "missing logo"
    if offer.image_url_small
      logo = image_tag(offer.image_url_small)
    elsif offer.user
      if offer.logo.file?
        logo = image_tag(offer.logo.url(:thumb))
      else
        logo = "<p><strong>#{offer.user.name}</strong></p>"
      end
    end
    if current_user && current_user.role == "business"
      if current_user.logo.file?
        logo = image_tag(current_user.logo.url(:thumb))
      else
        logo = "<p><strong>#{current_user.name}</strong></p>"
      end
    end
    type_name = offer.offer_type.name if offer.offer_type
    "
    <div class='coupon'>
      <h4 id='#{offer.id}_type' class='c_#{type_name || "Coupon"}'>#{type_name || 'coupon'}</h4>
        <div class='holder'>
          <div class='center'>
            <div class='add-logo'>
              #{logo}
            </div>
          </div>
       </div>
       #{coupon_body(offer)}
     </div>
    "
  end
  
  def info_for_rollover(offer)
    escape_javascript("<strong class=\"title\">#{offer.user.name.blank? ? offer.businesses.first.name : offer.user.name}: #{offer.title}</strong><p>#{strip_links(offer.description).try(:html_safe)}</p><p>#{offer.fine_print}</p><p>Expires #{std_date(offer.end_date)}</p>")
  end

  def list_offer(offer)
    "<li id='my_offer_#{offer.id}'>" +
    hidden_field_tag("user[offer_ids][]", offer.id) +
    link_to("<h3>#{offer.user.name.blank? ? offer.businesses.first.name : offer.user.name}: #{offer.title}</h3>".html_safe, viewdeal_path(offer),
      :onMouseOver => "$('#offer_info_rollover').html('#{info_for_rollover(offer)}');",
      :onMouseOut => "$('#offer_info_rollover').empty();"
    ) +
      "<p>Expires #{offer.end_date.strftime('%B %d, %Y')}</p></li>"
  end

  def undo_last_action_link(offer, liked=true)
    liked_bit = liked ? 1 : 0
    undo_link = link_to("Undo", { controller: "welcome", action: "undo_last_action", liked: liked_bit }, method: :post, remote: true)
    res = '<span class="mark">'
    if liked
      res << "You added <strong>#{offer.title}</strong> to My Picks. #{undo_link} or #{use_it_now_link(offer)}."
    else
      res << "You removed <strong>#{offer.title}</strong> from Artie's Picks. #{undo_link}."
    end
    res << "</span>"
  end

  def use_it_now_link(offer)
    if logged_in?
      if offer.redemption_link.blank?
        link_to("Use It Now", viewdeal_path(offer), {:class => "link"})
      else
        link_to("Get It Now", redeem_path(offer), {:class => "link"})
      end
    else
      link_to_function("Use It Now", "$('#signup-popup').modal();", {:class => "link"})
    end
  end

  def display_offer(offers, index, hidden=false)

    offer = offers[index]
    return if offer.nil?

"<li id='offer_#{offer.id}' #{"style='display:none;'" if hidden} onmouseover=\"$('#offer_info_rollover').html('"+ h(info_for_rollover(offer))+ "');\"
           onmouseout=\"$('#offer_info_rollover').empty()\" >"  +
  '<div class="frame">
    <div>' +
      deal_coupon(offer) +
    '</div>
  </div>
  <div class="rate">' +
    rate_link(offer, 1, image_tag('/images/btn-good.gif', alt: "+")) +
    use_it_now_link(offer) +
    rate_link(offer, 0, image_tag('/images/btn-bad.gif', alt: "-")) +
  '</div>
</li>'
  end

  def rate_link(offer, liked, display, response_type="gallery", html_class=nil)
    link_to(display, { controller: "welcome", action: "set_opinion", offer_id: offer.friendly_id, liked: liked, response_type: response_type }, method: :post, remote: true, class: html_class, "data-ajax" => "false", "data-role" => "button", "data-icon" => (liked == 1 ? "thumbsup" : "thumbsdown"))
  end

  def pay_button(num_credits, price)
    form_tag ActiveMerchant::Billing::Integrations::Paypal.service_url do
      hidden_field_tag(:cmd, "_s-xclick") +
      hidden_field_tag(:encrypted, current_user.paypal_encrypted(paypal_return_url, ppipn_url, num_credits, price, "Smartvark credit")) +
      image_submit_tag("http://www.paypalobjects.com/en_US/i/btn/btn_paynowCC_LG.gif", alt: "Pay Now", name: "submit")
    end
  end
end
