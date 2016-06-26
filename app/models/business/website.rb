class Business::Website < ApplicationRecord
  
  enum platform: [ :wordpress, :blogger ]
  
  validates :platform,     presence: true
  validates :url,          presence: true
  validates :url,          uniqueness: true
  validates :url,          url: true
  
  belongs_to  :business
  has_many    :backlinks, foreign_key: :business_website_id
  
  delegate :name, to: :business, prefix: true
  
  before_save :remove_trailing_slash
  
  def remove_trailing_slash
    if url_changed?
      uri = URI(url)
      self.url = "#{uri.scheme}://#{uri.host}"
    end
  end
  
  def self.find_by_uri(uri)
    uri = URI(uri)
    self.find_by_url("#{uri.scheme}://#{uri.host}")
  end
  

end
