class Partner::BacklinkDecorator < ApplicationRecordDecorator
  delegate_all
  
  STATUS_ICON_OPTIONS      = {default: ['circle-o-notch', 'spin'], active: 'check-square-o' , inactive: 'square-o' }
  STATUS_COLOR_OPTIONS     = {default:'muted', active: 'success', inactive: 'danger'}

  def name
    "#{h.i(self.class.icon)} Backlink ##{object.id}".html_safe
  end
  
  def referrer
    short_url(object.referrer)
  end
  
  def link
    short_url(object.link) 
  end
  
  def i_status
    "#{h.i(status_icon)} #{status}".html_safe
  end
  
  def status
    self.class.human_enum_name(:status, object.status || 'unknown').humanize
  end
  
  def status_icon
    option :status_icon, object.status
  end

  def status_color
    option :status_color, object.status
  end

  def self.icon
    'link'
  end

end
