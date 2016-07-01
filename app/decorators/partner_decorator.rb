class PartnerDecorator < ApplicationRecordDecorator
  delegate_all
  
  def name
    "#{h.i(self.class.icon)} #{object.title}".html_safe
  end
  
  def self.icon
    'users'
  end

end
