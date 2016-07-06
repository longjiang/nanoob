class UserDecorator < ApplicationRecordDecorator
  delegate_all
  
  def name
    object.username.humanize
  end
  
  def self.icon
    'user'
  end
end
