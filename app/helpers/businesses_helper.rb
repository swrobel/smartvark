module BusinessesHelper
  def form_row(form, field_name, label, other={}, type=:text_field)
    "<div class=\"row#{other[:tdc]}\">
      <label for=\"#{field_name}\"><span>#{label}</span><span class=\"inf\">Info</span></label>
      <div class=\"right\">
    " + form.send(type,field_name, :class => 'txt') +
    "#{other[:bf]}</div></div>"
  end
end
