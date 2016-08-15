class Business::Website < ApplicationRecord
  
  include Nanoob::Meta
  
  enum platform: [ :wordpress, :blogger, :nanoob ]
  
  THEMES = %w(simple lapoigneedemain.com)
  
  validates :business_id,  presence: true
  validates :platform,     presence: true
  validates :url,          presence: true
  validates :url,          uniqueness: true
  validates :url,          url: true
  validates :theme,        presence: true
  
  belongs_to  :business
  has_many    :backlinks, class_name: 'Partner::Backlink', foreign_key: :business_website_id
  has_many    :posts    , class_name: 'Blog::Post', foreign_key: :business_website_id
  
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
  
  def baseline=(baseline)
    set_meta(:baseline, baseline)
  end
  
  def baseline
    get_meta(:baseline)
  end
  
  def theme=(theme)
    set_meta(:theme, theme)
  end
  
  def theme
    get_meta(:theme) || self.class::THEMES[0]
  end

end

