class Business::Website < ApplicationRecord
  
  include Nanoob::Meta
  
  enum platform: [ :wordpress, :blogger, :nanoob ]
  
  THEMES = %w(simple lapoigneedemain.com sharing)
  
  validates :business_id,  presence: true
  validates :platform,     presence: true
  validates :url,          presence: true
  validates :url,          uniqueness: true
  validates :url,          url: true
  validates :theme,        presence: true
  
  belongs_to  :business    , counter_cache: true
  has_many    :backlinks   , class_name: 'Partner::Backlink'          , foreign_key: :business_website_id
  has_many    :pages       , class_name: 'Blog::Contents::Page'       , foreign_key: :business_website_id
  has_many    :posts       , class_name: 'Blog::Contents::Post'       , foreign_key: :business_website_id
  has_many    :categories  , class_name: 'Blog::Taxonomies::Category' , foreign_key: :business_website_id
  has_many    :tags        , class_name: 'Blog::Taxonomies::Tag'      , foreign_key: :business_website_id
  has_many    :stop_words  , class_name: 'Seo::StopWord'              , as: :excludable,      dependent: :delete_all
  has_many    :words       , class_name: 'Seo::Word'                  , as: :word_countable,  dependent: :delete_all
  has_many    :visits                                                 , foreign_key: :business_website_id
  has_many    :events      , class_name: 'Ahoy::Event'                , foreign_key: :business_website_id
  
  scope :has_categories , -> { (where "categories_count > 0 ")}
  scope :has_tags , -> { (where "tags_count > 0 ")}
  
  delegate :name, to: :business, prefix: true
  
  meta_accessor :title, :baseline, :owner_id, :author_id, :woopra, :page_title_template
  meta_writer   :theme, :words_count, :parent_theme
  
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
  
  def self.find_by_request(request)
    url = "#{request.protocol}#{request.host.gsub('.dev','').gsub('www.','')}"
    self.find_by_url url
  end
  
  def theme
    get_meta(:theme) || self.class::THEMES[0]
  end
  
  def parent_theme
    nil
  end
  
  def owner
    @owner ||= get_meta(:owner_id).present? ? People::User.find(get_meta(:owner_id)) : People::User.new
  end
  
  def author
    @author ||= get_meta(:author_id).present? ? People::Author.find(get_meta(:author_id)) : People::Author.new
  end
  
  def words_count
    @words_count ||= get_meta(:words_count).present? ? get_meta(:words_count).to_i : 0
  end
  
  def set_words_count
    self.words_count = posts.count
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
  
  def count_words
    self.words = Seo::Word.where(word_countable_type: "Blog::Content", word_countable_id: posts.collect(&:id)).group(:word).count.collect{ |token, frequency| Seo::Word.new(word: token, frequency: frequency)} 
  end
  
  def viewed_content(top=10)
    events
      .trackables
      .select("properties ->> 'trackable_type' as a, properties ->> 'trackable_id' as b, count(*)")
      .group("a, b")
      .collect { |_| [_.a, _.b, _.count] }
      .sort { |a,b| b[2] <=> a[2] }
      .first(top)
      .collect { |_| [_[0].constantize.find(_[1]), _[2]]}
  end

end

