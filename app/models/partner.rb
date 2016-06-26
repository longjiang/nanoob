class Partner < ApplicationRecord
  
  enum category: [ :undefined, :network_fr, :network_en, :blog, :forum, :facebook, :china, :entrepreneur, :student, :decoration, :family ]
  
  validates :title,         presence: true
  validates :category,      presence: true
  validates :url,           presence: true
  validates :url,           url: true
  validates_format_of :contact_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_nil: true
  validates :webform_url,   url: true,      allow_nil: true
  
  has_many :requests,   dependent: :destroy
  has_many :backlinks,  dependent: :destroy
  
  private
  
  def nilify_attributes
    %w(contact_email webform_url)
  end

end
