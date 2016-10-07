class Visit < ActiveRecord::Base
  has_many :events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true
  belongs_to :website, class_name: 'Business::Website', foreign_key: 'business_website_id'
  
  scope :yesterday, -> { where('started_at > ? and started_at < ?', Time.zone.now.yesterday.beginning_of_day, Time.zone.now.yesterday.end_of_day) }
  scope :today, -> { where('started_at > ? and started_at < ?', Time.zone.now.beginning_of_day, Time.zone.now.end_of_day) }
  
end
