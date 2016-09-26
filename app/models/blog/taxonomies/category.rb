class Blog::Taxonomies::Category < Blog::Taxonomy
  
  belongs_to :parent, optional: true, class_name: 'Blog::Taxonomies::Category'
  has_many :children, class_name: 'Blog::Taxonomies::Category', foreign_key: :parent_id
  
end