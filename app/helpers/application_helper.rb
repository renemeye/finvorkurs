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
    if (not(request.env['HTTP_USER_AGENT'].nil?) && request.env['HTTP_USER_AGENT'].match(/MSIE/))
      yield
    end
  end

  def markdown text
    RDiscount.new(text).to_html.html_safe
  end

  def editable_text key
    (best_in_place_if current_user && current_user.admin?, StaticText.get(key), :value, type: :textarea, sanitize: false, display_as: :markdown_text).html_safe
  end
  
  # Ausgabe: "Vor mehr als 5 Monaten"/"Vor etwa einem Jahr" — statt "Dauer: mehr als 5 Monate"/"Dauer: etwa 1 Jahr", wie es die Originalfunktion liefert
  # Original-File: actionpack/lib/action_view/helpers/date_helper.rb, line 63
  # Dokumenation: http://apidock.com/rails/v2.3.8/ActionView/Helpers/DateHelper/distance_of_time_in_words
  # Changelog: I18n.with_options-Scope geändert auf "distance_in_words_gebeugt"
  def distance_of_time_in_words_gebeugt(from_time, to_time = 0, include_seconds = false, options = {})
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
 
    I18n.with_options :locale => options[:locale], :scope => 'datetime.distance_in_words_gebeugt' do |locale|
      case distance_in_minutes
        when 0..1
          return distance_in_minutes == 0 ?
                 locale.t(:less_than_x_minutes, :count => 1) :
                 locale.t(:x_minutes, :count => distance_in_minutes) unless include_seconds
 
          case distance_in_seconds
            when 0..4   then locale.t :less_than_x_seconds, :count => 5
            when 5..9   then locale.t :less_than_x_seconds, :count => 10
            when 10..19 then locale.t :less_than_x_seconds, :count => 20
            when 20..39 then locale.t :half_a_minute
            when 40..59 then locale.t :less_than_x_minutes, :count => 1
            else             locale.t :x_minutes,           :count => 1
          end
 
        when 2..44           then locale.t :x_minutes,      :count => distance_in_minutes
        when 45..89          then locale.t :about_x_hours,  :count => 1
        when 90..1439        then locale.t :about_x_hours,  :count => (distance_in_minutes.to_f / 60.0).round
        when 1440..2529      then locale.t :x_days,         :count => 1
        when 2530..43199     then locale.t :x_days,         :count => (distance_in_minutes.to_f / 1440.0).round
        when 43200..86399    then locale.t :about_x_months, :count => 1
        when 86400..525599   then locale.t :x_months,       :count => (distance_in_minutes.to_f / 43200.0).round
        else
          distance_in_years           = distance_in_minutes / 525600
          minute_offset_for_leap_year = (distance_in_years / 4) * 1440
          remainder                   = ((distance_in_minutes - minute_offset_for_leap_year) % 525600)
          if remainder < 131400
            locale.t(:about_x_years,  :count => distance_in_years)
          elsif remainder < 394200
            locale.t(:over_x_years,   :count => distance_in_years)
          else
            locale.t(:almost_x_years, :count => distance_in_years + 1)
          end
      end
    end
  end
  # File actionpack/lib/action_view/helpers/date_helper.rb, line 115
  def time_ago_in_words_gebeugt(from_time, include_seconds = false)
    distance_of_time_in_words_gebeugt(from_time, Time.now, include_seconds)
  end
  alias distance_of_time_in_words_to_now_gebeugt time_ago_in_words_gebeugt

end
