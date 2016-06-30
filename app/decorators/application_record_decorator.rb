class ApplicationRecordDecorator < Draper::Decorator
  delegate_all
  
  def created_at
    object.created_at.strftime("%d/%m/%Y")
  end
  
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def self.icon
    'plus'
  end

end