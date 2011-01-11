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
  
  def footer_additions(elements)
    if elements == "jmapping"
      elements = javascript_include_tag('http://maps.google.com/maps/api/js?v=3.3&sensor=false', 'jmapping')
    end
    content_for(:footer_additions) { elements + "\n" }
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
    link_to(
    "
    <strong class=\"c_#{offer.offer_type.name}\">#{offer.offer_type.name}</strong>
    <div class=""img_box"">
      #{image_tag(offer.coupon.url(:thumb))}
    </div>
    <span id='#{offer.id}_title'>#{offer.title}</span>".html_safe,
    viewdeal_path(offer))
  end

  def coupon(offer)
    logo = image_tag(current_user.logo.url(:thumb)) if current_user.logo.exists?
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
    escape_javascript("<strong class=\"title\">#{offer.user.name}: #{offer.title}</strong><p>#{offer.description}</p><p>#{offer.fine_print}</p><p>Expires #{std_date(offer.end_date)}</p>")
  end

  def list_offer(offer)
    "<li id='my_offer_#{offer.id}'>" +
    hidden_field_tag("user[offer_ids][]", offer.id) +
    link_to("<h3>#{offer.user.name}: #{offer.title}</h3>".html_safe, viewdeal_path(offer),
      :onMouseOver => "$('#offer_info_rollover').html('#{info_for_rollover(offer)}');",
      :onMouseOut => "$('#offer_info_rollover').empty();"
    ) +
      "<p>Expires #{offer.end_date.strftime('%B %d, %Y')}</p></li>"
  end

  def undo_last_action_link(offer, liked=true)
    res = '<span class="mark">'
    if liked
      res << "You added \"#{offer.title}\" deal to My Picks. " +
      link_to("Undo", { :controller => "welcome", :action => "undo_last_action", :offer_id => offer.id, :liked => 1 }, :method => :post, :remote => true) + " or " +
      use_it_now_link(offer) + "."
    else
      res << "You removed \"#{offer.title}\" deal from Artie's Picks. " +
      link_to("Undo", { :controller => "welcome", :action => "undo_last_action", :offer_id => offer.id, :liked => 0 }, :method => :post, :remote => true) + "."
    end
    res << "</span>"
  end

  def use_it_now_link offer
    if logged_in?
      link_to("Use It Now", viewdeal_path(offer), {:class => "link"})
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
    link_to(image_tag('/images/btn-good.gif', :alt => "+"),
                   { :controller => "welcome", :action => "set_opinion", :offer_id => offer.id, :liked => 1 }, :method => :post, :remote => true) +
    use_it_now_link(offer) +
    link_to(image_tag('/images/btn-bad.gif', :alt => "-"),
                   { :controller => "welcome", :action => "set_opinion", :offer_id => offer.id, :liked => 0 }, :method => :post, :remote => true) +
  '</div>
</li>'
  end
end
