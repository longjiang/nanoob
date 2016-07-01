class UserDecorator < ApplicationRecordDecorator
  delegate_all
  
  def self.icon
    'user'
  end
end
