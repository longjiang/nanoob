class Partner < ApplicationRecord
  
  enum category: [ :undefined, :network_fr, :network_en, :blog, :forum, :facebook, :china, :entrepreneur, :student, :decoration, :family ]
  
  validates :title,         presence: true
  validates :category,      presence: true
  validates :url,           presence: true
  validates :url,           url: true
  validates_format_of :contact_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_nil: true
  validates :webform_url,   url: true,      allow_nil: true
  validates :user_id,       presence: true
  
  has_many :requests,   dependent: :destroy
  has_many :backlinks,  dependent: :destroy
  belongs_to :owner,    class_name: 'User',  foreign_key: :user_id
  
  scope :category,      -> (category)   { where category: category }
  scope :starts_with,   -> (title)      { where("lower(title) like ?", "#{title.downcase}%") }
  scope :contact,       -> (name)       { where("lower(contact_name) like ?", "%#{name.downcase}%")}
  scope :recent,        -> (days)       { where("created_at > ? ", days.to_i.days.ago) }
  scope :inactive,      -> (days)       { where("requests_count = 0 and backlinks_count = 0 and created_at > ? ", days.to_i.days.ago) }
  scope :owner,         -> (user)       { where owner: user.to_i }
  
  private
  
  def nilify_attributes
    %w(contact_email webform_url)
  end

end
