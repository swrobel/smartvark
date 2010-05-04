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

  def li_class(index)
    'active' if index.zero?
  end

  def display_offer(offer)
"<li id='offer_#{offer.id}'>"  +
  '<div class="frame">
    <div>
      <a href="http://www.codemyconcept.com/projects/155/inner.html#">' +
        image_tag(offer.coupon.url, :width => 175, :height => 100) +
      '</a>
    </div>
  </div>
  <div class="rate">' +
    link_to_remote(image_tag('/images/btn-good.gif', :alt => "+"),
                   :url => { :action => "set_opinion", :offer_id => offer.id, :liked => 'true' },
                   :complete => "shrink_and_move(#{offer.id})") +
    link_to_remote(image_tag('/images/btn-bad.gif', :alt => "+"),
                   :url => { :action => "set_opinion", :offer_id => offer.id, :liked => 'false' },
                   :complete => "shrink_and_move(#{offer.id})" ) +
  '</div>
</li>'
  end

end
