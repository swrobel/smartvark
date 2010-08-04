# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def std_date(date)
    date ?  date.strftime('%m/%d/%y') : 'N/A'
  end

  def coupon(offer=nil)
    "
  <div class='coupon'>
    <h4>COUPON</h4>
      <div class='holder'>
        <div class='center'>
          <div class='add-logo'>
            <a>Your Logo</a>
          </div>
        </div>
     </div>
     <span class='subttl'>#{offer.lead}</span>
     <p>#{offer.description}</p>
     <div class='code'>
       <p>#{offer.redemption_code}</p>
     </div>
   </div>
    "
    end
  end
