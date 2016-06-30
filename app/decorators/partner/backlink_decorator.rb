class Partner::BacklinkDecorator < ApplicationRecordDecorator
  delegate_all

  def self.icon
    'link'
  end

end
