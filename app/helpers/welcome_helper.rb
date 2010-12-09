module WelcomeHelper

  def categories
    @categories ||=Category.find_all_by_parent_id(nil)
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
    escape_javascript("<strong class=\"title\">#{offer.businesses.first.name}: #{offer.lead}</strong><p>#{offer.description}</p><p>#{offer.exclusivity_text}</p><p>#{offer.businesses.first.city}, #{offer.businesses.first.state} #{offer.businesses.first.postal_code}</p><p>Expires #{std_date(offer.expiry_datetime)}</p>")
  end

  def list_offer(offer)
    "<li id='my_offer_#{offer.id}'>" +
    hidden_field_tag("user[offer_ids][]", offer.id) +
    link_to("<h3>#{offer.businesses.first.name}: #{offer.lead}</h3>".html_safe, viewdeal_url(offer.to_param),
      :onMouseOver => "jQuery('#offer_info_rollover').html('#{info_for_rollover(offer)}');",
      :onMouseOut => "jQuery('#offer_info_rollover').empty();"
    ) +
      "<p>Expires #{offer.expiry_datetime.strftime('%B %d, %Y')}</p></li>"
  end

  def undo_last_action_link(offer, liked=true)
    res = '<span class="mark">'
    if liked
      res << "You added \"#{offer.lead}\" deal to My Picks. " +
      link_to("Undo", { :controller => "welcome", :action => "undo_last_action", :offer_id => offer.id }, :method => :post, :remote => true) + " or " +
      use_it_now_link(offer) + "."
    else
      res << "You removed \"#{offer.lead}\" deal from Artie's Picks. " +
      link_to("Undo", { :controller => "welcome", :action => "undo_last_action", :offer_id => offer.id }, :method => :post, :remote => true) + "."
    end
    res << "</span>"
  end
end
