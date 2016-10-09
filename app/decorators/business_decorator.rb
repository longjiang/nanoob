class BusinessDecorator < ApplicationRecordDecorator
  delegate_all
  
  def flag
    object.language.decorate.flag rescue '' 
  end
  
  def name
    "#{h.i(self.class.icon)} #{object.name}".html_safe
  end

  def self.icon
    'industry'
  end

end
