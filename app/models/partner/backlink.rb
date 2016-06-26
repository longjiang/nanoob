class Partner::Backlink < ApplicationRecord
  
  enum status: [ :active, :inactive ]
  
  before_validation :update_website
  
  validates   :link,       url: true,       allow_nil: true
  validates   :referrer,   url: true,       allow_nil: true
  validates   :website,    presence: true,  if: "link.present?"
  
  belongs_to  :partner
  belongs_to  :business
  belongs_to  :request, optional: true, class_name: 'Partner::Request',   foreign_key: :partner_request_id
  belongs_to  :owner,                   class_name: 'User',               foreign_key: :user_id
  belongs_to  :website, optional: true, class_name: "Business::Website",  foreign_key: :business_website_id
  
  delegate    :title, to: :partner, prefix: true
  delegate    :name, to: :business, prefix: true
  delegate    :username, to: :owner, prefix: true
  
  before_save :update_status_timestamp
  
  private
  
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
