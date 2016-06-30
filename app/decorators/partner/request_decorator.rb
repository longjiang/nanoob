class Partner::RequestDecorator < ApplicationRecordDecorator
  delegate_all

  def self.icon
    'file-text'
  end

end
