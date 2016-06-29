class Partner::BacklinkDecorator < Draper::Decorator
  delegate_all

  def self.icon
    'link'
  end

end
