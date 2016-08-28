class Blog::Category < ApplicationRecord
  
  belongs_to :website, class_name: 'Business::Website', foreign_key: :business_website_id, counter_cache: true
  belongs_to :parent, optional: true, class_name: 'Blog::Category'
  has_many :children, class_name: 'Blog::Category', foreign_key: :parent_id
  has_and_belongs_to_many :posts, class_name: 'Blog::Post',  foreign_key: :blog_category_id, association_foreign_key: :blog_post_id, after_add: :increment_count, after_remove: :decrement_count
  
  before_validation :humanize
  before_validation :slugify
  
  validates :name,          presence: true
  validates :slug,          presence: true
  validates :slug,          uniqueness: {scope: :business_website_id}
  
  scope :candidates,      -> (slug)       { where("slug like ?", "#{slug}%") } 
  scope :business_website_id,    -> (id)  { where business_website_id: id }
  
  def name_with_tag
    decorate.name_with_tag
  end
  
  def self.slugify(website, name)
    available_slug website, name.try(:parameterize)
  end
  
  private
  
  def increment_count(post)
    self.class.increment_counter(:posts_count, self.id)
    post.class.increment_counter(:categories_count, post.id)
  end
  
  def decrement_count(post)
    self.class.decrement_counter(:posts_count, self.id)
    post.class.decrement_counter(:categories_count, post.id)
  end
  
  def humanize
    self.name = name.try(:humanize)
  end
  
  def slugify
    self.slug = if slug.blank?
       available_slug name.try(:parameterize)
    elsif (slug_changed? && !new_record?)
       available_slug slug.gsub(/(.*)-[0-9]+[0_9a-z]*/, "\\1")
     else
       slug
    end
  end
  
  def available_slug(slug)
    self.class.available_slug(website, slug)
  end
  
  def self.available_slug(website, slug)
    return unless slug && website
    idx   = website.categories.candidates(slug).count 
    unless idx.eql?(0)
      seed = "--#{rand(10000000)}--#{Time.now}--#{rand(10000000)}"
      slug  = "#{slug}-#{idx+1}#{Digest::SHA1.hexdigest(seed)[0,3]}" 
    end
    slug
  end
  
end
