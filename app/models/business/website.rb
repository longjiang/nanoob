class Business::Website < ApplicationRecord
  
  include Nanoob::Meta
  
  has_meta :title, :baseline, :theme, :owner_id, :author_id
  
  enum platform: [ :wordpress, :blogger, :nanoob ]
  
  THEMES = %w(simple lapoigneedemain.com)
  
  validates :business_id,  presence: true
  validates :platform,     presence: true
  validates :url,          presence: true
  validates :url,          uniqueness: true
  validates :url,          url: true
  validates :theme,        presence: true
  
  belongs_to  :business    , counter_cache: true
  has_many    :backlinks   , class_name: 'Partner::Backlink', foreign_key: :business_website_id
  has_many    :pages       , class_name: 'Blog::Contents::Page', foreign_key: :business_website_id
  has_many    :posts       , class_name: 'Blog::Contents::Post', foreign_key: :business_website_id
  has_many    :categories  , class_name: 'Blog::Taxonomies::Category', foreign_key: :business_website_id
  has_many    :tags        , class_name: 'Blog::Taxonomies::Tag', foreign_key: :business_website_id
  
  scope :has_categories , -> { (where "categories_count > 0 ")}
  scope :has_tags , -> { (where "tags_count > 0 ")}
  
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
  
  def theme
    get_meta(:theme) || self.class::THEMES[0]
  end
  
  def owner_id
    get_meta(:owner_id) || People::User.first.id
  end
  
  def add_unknown_category(slug)
    categories = unknown_categories
    categories << slug
    set_meta(:unknown_categories, categories.uniq) 
  end
  
  def unknown_categories
    get_meta(:unknown_categories) || []
  end
  
  def add_unknown_tag(slug)
    tags = unknown_tags
    tags << slug
    set_meta(:unknown_tags, tags.uniq) 
  end
  
  def unknown_tags
    get_meta(:unknown_tags) || []
  end
  
  # mandatory for grouped_collection_select?
  def host
    decorate.host
  end

end

