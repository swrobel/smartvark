module BusinessesHelper
  def form_row(form, field_name, label, other={}, tooltip = '')
    "<div class=\"row#{other[:tdc]}\">
      <label for=\"#{field_name}\"><span>#{label}</span><span class=\"inf\" title=\"#{tooltip}\">Info</span></label>
      <div class=\"right\">
    " + form.text_field(field_name, :class => 'txt') +
    "#{other[:bf]}</div></div>"
  end
end
