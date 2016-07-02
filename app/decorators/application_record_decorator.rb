class ApplicationRecordDecorator < Draper::Decorator
  delegate_all
  
  ATTR_ICON_OPTIONS = {} 
  
  def short_date_format
    "%d/%m/%Y"
  end
  
  def short_url(url)
    uri = URI(url)
    "#{uri.host.gsub('www.', '')}#{uri.path}"
  end
  
  def created_at
    object.created_at.strftime(short_date_format)
  end
  
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  
  
  def option(options, value)
    options = self.class.const_get "#{options.upcase}_OPTIONS"
    self.class.option options, value
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