class Business::WebsiteDecorator < ApplicationRecordDecorator
  delegate_all

  def host
    uri = URI(object.url)
    uri.host
  end
  
  def platform
    object.platform.humanize
  end
  
  def self.icon
    'globe'
  end

end
