class Partner::Backlink < ApplicationRecord
  
  enum status: [ :active, :inactive ]
  
  before_validation :update_website
  before_save :update_status_timestamp
  
  validates   :link,                url: true,       allow_nil: true
  validates   :referrer,            url: true,       allow_nil: true
  validates   :website,             presence: { message: "link does not match any of our websites", if: "link.present?" } 
  validates   :partner_id,          presence: true
  validates   :business_id,         presence: true
  validates   :anchor,              presence: true,  if: "link.present?"
  
  belongs_to  :partner, counter_cache: true
  belongs_to  :business
  belongs_to  :request, optional: true, class_name: 'Partner::Request',   foreign_key: :partner_request_id
  belongs_to  :owner,                   class_name: 'User',               foreign_key: :user_id
  belongs_to  :website, optional: true, class_name: "Business::Website",  foreign_key: :business_website_id, counter_cache: true
  
  delegate    :title,    to: :partner, prefix: true
  delegate    :name,     to: :business, prefix: true
  delegate    :username, to: :owner, prefix: true
  
  scope :owner,         -> (user)       { where owner: user.to_i }
  scope :status,        -> (status)      { where status: status }
  scope :recent,        -> (days)       { where("updated_at > ? ", days.to_i.days.ago) }
  scope :business_id,   -> (id)         { where business_id: id }
  
  private
  
  def nilify_attributes
    %w( referrer link )
  end
  
  def update_status_timestamp
    unless new_record? && activated_at.present?
      self.activated_at   = Time.now if status_changed? && active?
    end
    unless new_record? && deactivated_at.present?
      self.deactivated_at = Time.now if status_changed? && inactive?
    end
  end
  
  def update_website
    unless new_record? && website.present? || !link_changed? || link.nil?
      self.website = Business::Website.find_by_uri(link)
    end
  end
  
end
