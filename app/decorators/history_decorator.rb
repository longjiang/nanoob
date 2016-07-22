class HistoryDecorator < ApplicationRecordDecorator
  delegate_all
  
  def valid_from
    object.valid_from.strftime(datetime_format)
  end
  
end