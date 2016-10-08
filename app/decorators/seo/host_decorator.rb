class Seo::HostDecorator < ApplicationRecordDecorator
  
  CATEGORY_ICON_OPTIONS = { default:'', uncategorized:'question-circle-o', social_network:'share-alt', blog:'user', news:'tv', reference: 'university', shopping: 'shopping-cart' }
  
  def name
    object.url
  end
  
  def chart_url
    h.truncate name, length: 15
  end
  
  def category_icon
   option :category_icon, category
  end
  
  def self.icon
    'map-o'
  end
  
end
