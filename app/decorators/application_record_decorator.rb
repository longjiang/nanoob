class ApplicationRecordDecorator < Draper::Decorator
  delegate_all
  
  ATTR_ICON_OPTIONS = {} 
  
  def short_date_format
    "%d/%m/%y"
  end
  
  def short_date_format_without_year
    "%d/%m"
  end
  
  def datetime_format
    "%d/%m/%y %H:%M"
  end
  
  def short_url(url)
    begin
      uri = URI(url)
      "#{uri.host.gsub('www.', '')}#{uri.path}"
    rescue
      url
    end
  end
  
  def created_at
    object.created_at.strftime(short_date_format)
  end
  
  def has_errors(attr=nil)
    if attr
      object.errors && object.errors[attr].present?
    else
      object.errors.present?
    end
  end
  
  def time_ago_in_words_or_date(date, threshold=nil)
    return nil unless date
    threshold = 30.days.ago if threshold.nil?
    if date < threshold
      date.strftime(date.year.eql?(Time.now.year) ? short_date_format_without_year : short_date_format)
    else
      h.time_ago_in_words date
    end
  end
  
  def time_ago_in_words_or_datetime(date, threshold=nil)
    return nil unless date
    threshold = 30.days.ago if threshold.nil?
    if date < threshold
      date.strftime(datetime_format)
    else
     "#{date > Time.now ? 'in ' : ''}#{h.time_ago_in_words(date)}#{date < Time.now ? ' ago' : ''}"
    end
  end
  
  
  def option(options, value)
    options = self.class.const_get "#{options.upcase}_OPTIONS"
    self.class.option options, value
  end

  def attribute_icon(attr)
    self.class.attribute_icon attr
  end
  
  def show_page_title(size=:xl)
    length = case size
    when :xs
      18
    when :sm
      30
    when :md
      35
    when :lg
      40
    else
      99
    end
    h.truncate(name, length: length).html_safe
  end
  
  def self.option(options, value)
    return options[:default] if value.nil?
    options.key?(value.to_sym) ? options[value.to_sym] : options[:default]
  end

  def self.icon
    'plus'
  end
  
  def self.attribute_icon(attr)
    option ({default: ''}.merge(self::ATTR_ICON_OPTIONS)), attr
  end
  
  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end

end