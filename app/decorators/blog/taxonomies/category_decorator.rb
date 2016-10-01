class Blog::Taxonomies::CategoryDecorator < Blog::TaxonomyDecorator
  
  def taxonomy_slug
    'category'
  end
  
  def self.icon
    'list'
  end
  
end