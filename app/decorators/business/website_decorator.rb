class Business::WebsiteDecorator < ApplicationRecordDecorator
  delegate_all
  
  def name
    "#{h.i(self.class.icon)} #{host}".html_safe
  end

  def host
    uri = URI(object.url)
    uri.host
  end
  
  def platform
    object.platform.try(:humanize)
  end
  
  def title
    object.title.blank? ? object.business.name : object.title
  end
  
  def self.icon
    'globe'
  end

end
