module ApplicationHelper

  def twitterized_type(type)
    case type
      when :alert
        "alert alert-warning"
      when :error
        "alert alert-error"
      when :notice
        "alert alert-info"
      when :success
        "alert alert-success"
      else
        type.to_s
    end
  end

  def ie
    if request.env['HTTP_USER_AGENT'].match /MSIE/
      yield
    end
  end

  def markdown text
    RDiscount.new(text).to_html.html_safe
  end

  def editable_text key
    (best_in_place_if @current_user && @current_user.admin?, StaticText.get(key), :value, type: :textarea, sanitize: false, display_as: :markdown_text).html_safe
  end
  
end
