class PartnerDecorator < ApplicationRecordDecorator
  delegate_all
  
  ATTR_ICON_OPTIONS = {category: 'list', contact: 'user'}
  
  def name
    "#{h.i(self.class.icon)} #{object.title}".html_safe
  end
  
  def category
    "#{h.i(self.class.attribute_icon(:category))} #{object.category.humanize}".html_safe
  end
  
  def owner
    object.owner.username
  end
  
  
  
  def self.icon
    'users'
  end
  
 

end
