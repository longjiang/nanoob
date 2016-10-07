module Ahoy
  class Event < ActiveRecord::Base
    include Ahoy::Properties
    include Storext.model

    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :user, optional: true
    belongs_to :website, class_name: 'Business::Website', foreign_key: 'business_website_id'
    
    store_attributes :properties do
      #subscribed_to_newsletter Boolean, default: false
      trackable_type String
      trackable_id Integer
    end
    
    def trackable
      trackable_type.constantize.find trackable_id unless trackable_type.nil?
    end
    
    scope :views, -> {where(name: '$view')}
    scope :yesterday, -> { where('time > ? and time < ?', Time.zone.now.yesterday.beginning_of_day, Time.zone.now.yesterday.end_of_day) }
    scope :today, -> { where('time > ? and time < ?', Time.zone.now.beginning_of_day, Time.zone.now.end_of_day) }
   
    #scope :viewables, -> {}
    
  end
end
