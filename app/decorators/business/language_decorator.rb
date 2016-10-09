class Business::LanguageDecorator < ApplicationRecordDecorator
  
  delegate_all
  
  def flag
    h.flag(object.isocode, object.name).html_safe
  end
  
end