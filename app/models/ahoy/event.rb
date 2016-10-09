module Ahoy
  class Event < ActiveRecord::Base
    include Ahoy::Properties
    include Storext.model

    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :user, optional: true
    belongs_to :website, class_name: 'Business::Website', foreign_key: 'business_website_id'
    
    store_attributes :properties do
      trackable_type String
      trackable_id Integer
    end
    
    scope :views, -> {where(name: '$view')}
    scope :yesterday, -> { where('time > ? and time < ?', Time.zone.now.yesterday.beginning_of_day, Time.zone.now.yesterday.end_of_day) }
    scope :today, -> { where('time > ? and time < ?', Time.zone.now.beginning_of_day, Time.zone.now.end_of_day) }
    scope :trackables, -> {where("#{self.table_name}.name = ?", Trackable::EVENT_NAME)}
    
    def trackable
      trackable_type.constantize.find trackable_id unless trackable_type.nil?
    end
    
    def self.count_trackables(top=10)
        trackables
        .select("properties ->> 'trackable_type' as a, properties ->> 'trackable_id' as b, count(*)")
        .group("a, b")
        .collect { |_| [_.a, _.b, _.count] }
        .sort { |a,b| b[2] <=> a[2] }
        .first(top)
        .collect { |_| [_[0].constantize.find(_[1]), _[2]]}
    end
    
  end
end
