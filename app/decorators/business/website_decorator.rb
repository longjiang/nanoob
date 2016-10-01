class Business::WebsiteDecorator < ApplicationRecordDecorator
  
  delegate_all
  
  PAGE_TITLE_TEMPLATE_DEFAULT = "%%page_title%% | %%sitename%%"
  PAGE_TITLE_TEMPLATE_OPTIONS = %w(page_title sitename)  # methods must exist in Blog::Public::MetaConcern (or in controllers)
  
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
  
  def page_title_template
    object.page_title_template || PAGE_TITLE_TEMPLATE_DEFAULT
  end
  
  def self.icon
    'globe'
  end

end
