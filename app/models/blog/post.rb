class Blog::Post < ApplicationRecord
  
  include Nanoob::Meta
  #include Bootsy::Container
  
  attachment :featured_image, type: :image
  
  enum status: [:draft, :published]
  
  before_validation :default_status
  before_validation :slugify
  
  validates   :title,         presence: true
  validates   :slug,          presence: true
  validates   :slug,          uniqueness:  { scope: :business_website_id }
  #validates_format_of :slug, :without => /^\d/
  
  belongs_to :website,  class_name: 'Business::Website', foreign_key: :business_website_id
  belongs_to :owner,    class_name: 'User',  foreign_key: :user_id
  
  scope :owner,           -> (user)       { where owner: user.to_i }
  scope :recent,          -> (days)       { where("updated_at > ? ", days.to_i.days.ago) }
  scope :business_website_id,    -> (id)  { where business_website_id: id }
  scope :website,         -> (website)    { where business_website_id: website.id }
  scope :candidates,      -> (slug)       { where("slug like ?", "#{slug}%") } 
  scope :title_contains,  -> (title)      { where("lower(title) like ?", "%#{title.downcase}%") }
  scope :status,          -> (status)     { where status: status }
  scope :published_after, -> (date)       { where("published_at > ? ", date) }
  scope :published_before,-> (date)       { where("published_at < ? ", date) }
  
  def self.sort_by_status_date(direction='asc')
    #status=0 means status=:draft (enum is stored as integer)
    order("case when status=0 then updated_at else COALESCE(published_at, updated_at) end #{direction}")
  end
  
  delegate :username, to: :owner, prefix: true 
  
  attr_writer :body_xs

  def body_xs
    @body_xs ||= body
  end

  def year
    (published_at.nil? ? Time.now : published_at).strftime('%Y')
  end
  
  def month
    (published_at.nil? ? Time.now : published_at).strftime('%m')
  end
  
  def seo_score=(seo_score)
    set_meta(:seo_score, seo_score)
  end
  
  def seo_score
    get_meta(:seo_score)
  end
  
  def self.slugify(title)
    available_slug title.try(:parameterize)
  end
  
  private
  
  def nilify_attributes
    %w( title slug body )
  end
  
  def default_status
    self.status = :draft if status.blank? 
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
