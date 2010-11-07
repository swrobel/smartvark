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
    "<strong class=\"title\">#{offer.business.name}: #{offer.lead}</strong><p>#{offer.description}</p><p>#{offer.exclusivity_text}</p><p>#{offer.business.city}, #{offer.business.state} #{offer.business.postal_code}</p><p>Expires #{std_date(offer.expiry_datetime)}</p>".gsub(/'/,"\\\'")
  end

  def list_offer(offer)
    "<li id='offer_#{offer.id}'>" +
    hidden_field_tag("user[offer_ids][]", offer.id) +
    link_to("<h3>#{offer.business.name}: #{offer.lead}</h3>", viewdeal_url(offer.to_param),
      :onMouseOver => "$('offer_info_rollover').update('#{info_for_rollover(offer)}');",
      :onMouseOut => "$('offer_info_rollover').update('');"
    ) +
      "<p>Expires #{offer.expiry_datetime.strftime('%B %d, %Y')}</p></li>"
  end

  def undo_last_action_link(offer, liked=true)
    res = '<span class="mark">'
    if liked
      res << "You added \"#{offer.lead}\" deal to My Picks. " +
      link_to_remote("undo", :url => undo_last_action_path(offer.id)) + " or " +
      use_it_now_link(offer) + "."
    else
      res << "You removed \"#{offer.lead}\" deal from Artie's Picks. " +
      link_to_remote("undo", :url => undo_last_action_path(offer.id)) + "."
    end
    res << "</span>"
  end
end
