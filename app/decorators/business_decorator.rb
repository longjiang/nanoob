class BusinessDecorator < ApplicationRecordDecorator
  delegate_all
  
  def name
    "#{h.i(self.class.icon)} #{object.name}".html_safe
  end
  
  def flag
    h.flag(object.language).html_safe
  end

  def self.icon
    'industry'
  end

end
