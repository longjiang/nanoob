class PartnerDecorator < Draper::Decorator
  delegate_all
  
  def self.icon
    'users'
  end

end
