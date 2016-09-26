class Blog::Taxonomies::Category < Blog::Taxonomy
  
  belongs_to :website, class_name: 'Business::Website', foreign_key: :business_website_id, counter_cache: true
  belongs_to :parent, optional: true, class_name: 'Blog::Taxonomies::Category'
  has_many :children, class_name: 'Blog::Taxonomies::Category', foreign_key: :parent_id
  has_and_belongs_to_many :posts, class_name: 'Blog::Post',  foreign_key: :blog_taxonomy_id, association_foreign_key: :blog_post_id, after_add: :increment_count, after_remove: :decrement_count
  
  private
  
  def increment_count(post)
    self.class.increment_counter(:posts_count, self.id)
    post.class.increment_counter(:categories_count, post.id)
  end
  
  def decrement_count(post)
    self.class.decrement_counter(:posts_count, self.id)
    post.class.decrement_counter(:categories_count, post.id)
  end
  
end