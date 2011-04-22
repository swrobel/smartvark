module BusinessesHelper
  def form_row(form, field_name, label, other={}, tooltip = '')
    label_html = "<span>#{label}</span><span class=\"inf\" title=\"#{tooltip}\"></span>".html_safe
    output = "<div class=\"row#{other[:tdc]}\">
      #{form.label(field_name,label_html)}
      <div class=\"right\">
    #{form.text_field(field_name, :class => 'txt')}
    #{other[:bf]}</div></div>"
    return output.html_safe
  end
end
