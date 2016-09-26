class Blog::Taxonomy < ApplicationRecord
  
  
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
  
  def self.slugify(name, website)
    available_slug website, name.try(:parameterize)
  end
  
  private
  

  
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
