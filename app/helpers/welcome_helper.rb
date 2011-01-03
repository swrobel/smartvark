module WelcomeHelper

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
end
