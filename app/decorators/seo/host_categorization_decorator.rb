class Seo::HostCategorizationDecorator < ApplicationRecordDecorator
  
  CATEGORY_ICON_OPTIONS = {default:'', internal: 'refresh', network: 'sitemap', other: 'connectdevelop' }
  
  
  def name
    'No Name'
  end
  
  def category_icon
   option :category_icon, category
  end
  
  def updated_at
    time_ago_in_words_or_date(object.updated_at)
  end
  
  def self.icon
    'cubes'
  end
  
end
