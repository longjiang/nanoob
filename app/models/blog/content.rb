class Blog::Content < ApplicationRecord
  
  include Nanoob::Meta
  include Trackable
  #include Bootsy::Container
  
  attachment :featured_image, type: :image
  
  enum status: [:draft, :published, :submitted]
  
  before_validation :default_status
  before_validation :slugify
  before_save :default_published_at
  
  validates   :business_website_id,         presence: true
  validates   :title,         presence: true
  validates   :slug,          presence: true
  validates   :slug,          uniqueness:  { scope: :business_website_id }
  #validates_format_of :slug, :without => /^\d/
  
  has_many    :anchors,    class_name: 'Seo::Anchor', foreign_key: 'blog_content_id'
    
  scope :owner,           -> (staff)      { where owner: staff.to_i }
  scope :editor,          -> (staff)      { where editor: staff.to_i }
  scope :writer,          -> (staff)      { where writer: staff.to_i }
  scope :optimizer,       -> (staff)      { where optimizer: staff.to_i }
  scope :mine,            -> (staff)      { where "owner_id = ? or editor_id = ? or writer_id = ? or optimizer_id = ?", staff.to_i, staff.to_i, staff.to_i, staff.to_i}
  scope :recent,          -> (days)       { where("#{self.table_name}.updated_at > ? ", days.to_i.days.ago) }
  scope :business_website_id,    -> (id)  { where business_website_id: id }
  scope :website,         -> (website)    { where business_website_id: website.id }
  scope :candidates,      -> (slug)       { where("#{self.table_name}.slug like ?", "#{slug}%") } 
  scope :title_contains,  -> (title)      { where("lower(title) like ?", "%#{title.downcase}%") }
  scope :status,          -> (status)     { where status: status }
  scope :published_after, -> (date)       { where("#{self.table_name}.published_at > ? ", date) }
  scope :published_before,-> (date)       { where("#{self.table_name}.published_at < ? ", date) }
  scope :category_id,     -> (id)         { joins(:categories).where('blog_taxonomies.id = ?', id) }
  scope :tag_id,          -> (id)         { joins(:tags).where('blog_taxonomies.id = ?', id) }
  scope :publicized,      ->              { where(status: :published).where("#{self.table_name}.published_at < ? ", Time.now) }
  scope :scheduled,       ->              { where(status: :published).where("#{self.table_name}.published_at > ? ", Time.now) }
 
 
  def self.sort_by_status_date(direction='asc')
    #status=0 means status=:draft (enum is stored as integer)
    order("case when status in (0,2) then #{self.table_name}.updated_at else COALESCE(#{self.table_name}.published_at, #{self.table_name}.updated_at) end #{direction}")
  end
  
  delegate :username, to: :owner, prefix: true
  
  attr_writer :body_xs
  
  meta_accessor :seo_score, :author_id

  def body_xs
    @body_xs ||= body
  end

  def year
    (published_at.nil? ? Time.now : published_at).strftime('%Y')
  end
  
  def month
    (published_at.nil? ? Time.now : published_at).strftime('%m')
  end
  
  def author
    @author ||= get_meta(:author_id).present? ? People::Author.find(get_meta(:author_id)) : website.author
  end
  
  def author?
    !author.new_record?
  end
  
  
  def update_views_count
    self.views_count  = events.count
    @views_count      = events.count
  end
  
  def sanitized_body
     @sanitized_body ||= (ActionView::Base.full_sanitizer.sanitize body || '')
  end
  
  def sanitized_title
    @sanitized_title ||= (ActionView::Base.full_sanitizer.sanitize title || '')
  end
  
  def self.slugify(title, website)
    available_slug title.try(:parameterize)
  end
  
  def visits
    @visits ||= Visit.joins(:events).where('ahoy_events.name = ?', Trackable::EVENT_NAME).where("properties ->> 'trackable_id' = ?) AND (properties ->> 'trackable_type' = ?", id.to_s, self.class.name)
  end
  
  def events
    @events ||= Ahoy::Event.trackables.where_properties(trackable_id: id, trackable_type: self.class.name)
  end
  
  def publicized?
    published? && published_at < Time.now
  end
  
  private
  
  def increment_category_count(category)
    self.class.increment_counter(:categories_count, self.id)
    category.class.increment_counter(:posts_count, category.id)
  end
  
  def decrement_category_count(category)
    self.class.decrement_counter(:categories_count, self.id)
    category.class.decrement_counter(:posts_count, category.id)
  end
  
  def increment_tag_count(tag)
    tag.class.increment_counter(:posts_count, tag.id)
  end
  
  def decrement_tag_count(tag)
    tag.class.decrement_counter(:posts_count, tag.id)
  end
  
  def nilify_attributes
    %w( title slug body )
  end
  
  def default_status
    self.status = :draft if status.blank? 
  end
  
  def default_published_at
    self.published_at = Time.now if published_at.blank? && published?
  end
  
  def slugify
    self.slug = if slug.blank?
       available_slug title.try(:parameterize)
    elsif slug_changed?
       available_slug slug.gsub(/(.*)-[0-9]+[0_9a-z]*/, "\\1")
     else
       slug
    end
  end
  
  def available_slug(slug)
    self.class.available_slug(slug)
  end
  
  def self.available_slug(slug)
    return if slug.nil?
    idx   = candidates(slug).count 
    unless idx.eql?(0)
      seed = "--#{rand(10000000)}--#{Time.now}--#{rand(10000000)}"
      slug  = "#{slug}-#{idx+1}#{Digest::SHA1.hexdigest(seed)[0,3]}" 
    end
    slug
  end
  
  
  
end