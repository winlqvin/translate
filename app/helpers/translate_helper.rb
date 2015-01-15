module TranslateHelper

  def simple_filter(labels, param_name = 'filter', selected_value = nil)
    selected_value ||= params[param_name]
    filter = []
    labels.each do |item|
      if item.is_a?(Array)
        type, label = item
      else
        type = label = item
      end
      if type.to_s == selected_value.to_s
        filter << "<i>#{label}</i>"
      else
        link_params = params.merge({param_name.to_s => type})
        link_params.merge!({"page" => nil}) if param_name.to_s != "page"
        filter << link_to(label, link_params)
      end
    end
    filter.join(" | ")
  end

  def n_lines(text, line_size)
    n_lines = 1
    if text.present?
      n_lines = text.split("\n").size
      if n_lines == 1 && text.length > line_size
        n_lines = text.length / line_size + 1
      end
    end
    n_lines
  end

  def translate_javascript_includes
    if File.exists?(File.join(Rails.root, "public", "javascripts", "prototype.js"))
      javascript_include_tag("prototype.js")
    else
      javascript_include_tag("http://ajax.googleapis.com/ajax/libs/prototype/1.7.0.0/prototype.js")
    end
  end

  def translate_link(key, text, from, to)
    method = if Translate.app_id
      'getBingTranslation'
    elsif Translate.api_key
      'getGoogleTranslation'
    else
      nil
    end
    return nil unless method
    link_to_function 'Auto Translate', "#{method}('#{key}', \"#{escape_javascript(text)}\", '#{from}', '#{to}')", :style => 'padding: 0; margin: 0;'
  end

  # copy/paste of missing function, because it was deprecated in Rails 4.1
  def button_to_function(name, function=nil, html_options={})
    message = "button_to_function is deprecated and will be removed from Rails 4.1. We recommend using Unobtrusive JavaScript instead. " +
      "See http://guides.rubyonrails.org/working_with_javascript_in_rails.html#unobtrusive-javascript"
    ActiveSupport::Deprecation.warn message

    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function};"

    tag(:input, html_options.merge(:type => 'button', :value => name, :onclick => onclick))
  end

  # copy/paste of missing function, because it was deprecated in Rails 4.1
  def link_to_function(name, function, html_options={})
    message = "link_to_function is deprecated and will be removed from Rails 4.1. We recommend using Unobtrusive JavaScript instead. " +
      "See http://guides.rubyonrails.org/working_with_javascript_in_rails.html#unobtrusive-javascript"
    ActiveSupport::Deprecation.warn message

    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || '#'

    content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end

end
