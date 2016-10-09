module Trackable
  
  EVENT_NAME = "Viewed trackable"
  
  extend ActiveSupport::Concern
  include Nanoob::Meta 
  
  included do
    meta_writer :views_count
  end
  
  def views_count
    @views_count ||= get_meta(:views_count).present? ? get_meta(:views_count).to_i : 0
  end
  
  def track(controller)
    Ahoy::Tracker.new(controller: controller).track EVENT_NAME, trackable_type: self.class.name, trackable_id: self.id
  end
  
end