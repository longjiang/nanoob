class PartnerDecorator < ApplicationRecordDecorator
  delegate_all
  
  def self.icon
    'users'
  end

end
