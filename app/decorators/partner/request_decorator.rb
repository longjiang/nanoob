class Partner::RequestDecorator < Draper::Decorator
  delegate_all

  def self.icon
    'file-text'
  end

end
