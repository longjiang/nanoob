module Trackable
  
  extend ActiveSupport::Concern
  
  EVENT_NAME = "Viewed trackable"
  
  def track(controller)
    Ahoy::Tracker.new(controller: controller).track EVENT_NAME, trackable_type: self.class.name, trackable_id: self.id
  end
  
end