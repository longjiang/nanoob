class Partner < ApplicationRecord
  
  enum category: [ :undefined, :network_fr, :network_en, :blog, :forum, :facebook, :china, :entrepreneur, :student, :decoration, :family ]
  
  validates :title,         presence: true
  validates :category,      presence: true
  validates :url,           presence: true
  validates :url,           url: true
  validates_format_of :contact_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_nil: true
  validates :webform_url,   url: true,      allow_nil: true
  validates :owner_id,       presence: true
  
  validates :contact_email, presence: true, if: "pending_request_id.present? && pending_request.email?"
  validates :contact_name,  presence: true, if: "pending_request_id.present? && pending_request.email?"
  validates :webform_url,   presence: true, if: "pending_request_id.present? && pending_request.webform?"
  
  has_many :requests,   dependent: :destroy
  has_many :backlinks,  dependent: :destroy
  belongs_to :owner,    class_name: 'People::User',  foreign_key: :owner_id
  
  attr_accessor :pending_request_id 
  
  delegate :username, to: :owner, prefix: true
  
  scope :category,      -> (category)   { where category: category }
  scope :starts_with,   -> (title)      { where("lower(title) like ?", "#{title.downcase}%") }
  scope :contact,       -> (name)       { where("lower(contact_name) like ?", "%#{name.downcase}%")}
  scope :recent,        -> (days)       { where("created_at > ? ", days.to_i.days.ago) }
  scope :inactive,      -> (days)       { where("requests_count = 0 and backlinks_count = 0 and created_at > ? ", days.to_i.days.ago) }
  scope :owner,         -> (staff)       { where owner: staff.to_i }
  
  def pending_request
    Partner::Request.find_by_id(pending_request_id) if pending_request_id
  end
  
  def is_valid_for_email_request?
    contact_email.present? && contact_name.present?
  end
  
  def is_valid_for_webform_request?
    webform_url.present?
  end
  
  private
  
  def nilify_attributes
    %w(contact_email webform_url)
  end

end
