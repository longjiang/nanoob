class Blog::Taxonomies::TagDecorator < Blog::TaxonomyDecorator
  
  def taxonomy_slug
    'tag'
  end
  
  def self.icon
    'tag'
  end
  
end