class Blog::Taxonomies::Tag < Blog::Taxonomy
  
  belongs_to :website, class_name: 'Business::Website', foreign_key: :business_website_id, counter_cache: true
  has_and_belongs_to_many :posts, class_name: 'Blog::Contents::Post',  foreign_key: :blog_taxonomy_id, association_foreign_key: :blog_content_id, after_add: :increment_count, after_remove: :decrement_count
  
  private
  
  def increment_count(post)
    self.class.increment_counter(:posts_count, self.id)
  end
  
  def decrement_count(post)
    self.class.decrement_counter(:posts_count, self.id)
  end
  
end