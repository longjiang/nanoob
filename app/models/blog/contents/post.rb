class Blog::Contents::Post < Blog::Content
  
  belongs_to :website,  class_name: 'Business::Website', foreign_key: :business_website_id, counter_cache: true
  belongs_to :owner,                      class_name: 'People::User',  foreign_key: :owner_id,     counter_cache: true
  belongs_to :editor,    optional: true,  class_name: 'People::User',  foreign_key: :editor_id,    counter_cache: true
  belongs_to :writer,    optional: true,  class_name: 'People::User',  foreign_key: :writer_id,    counter_cache: true
  belongs_to :optimizer, optional: true,  class_name: 'People::User',  foreign_key: :optimizer_id, counter_cache: true
  has_and_belongs_to_many :categories,  class_name: 'Blog::Taxonomies::Category',   foreign_key: :blog_content_id, association_foreign_key: :blog_taxonomy_id , after_add: :increment_category_count, after_remove: :decrement_category_count
  has_and_belongs_to_many :tags,        class_name: 'Blog::Taxonomies::Tag',        foreign_key: :blog_content_id, association_foreign_key: :blog_taxonomy_id , after_add: :increment_tag_count, after_remove: :decrement_tag_count

end
