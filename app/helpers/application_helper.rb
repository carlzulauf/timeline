module ApplicationHelper
  def js_global(global_name, data)
    javascript_tag "window.#{global_name} = #{data.to_json};".html_safe
  end
end
