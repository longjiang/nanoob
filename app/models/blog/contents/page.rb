class Blog::Contents::Page < Blog::Content
  
  belongs_to :website,  class_name: 'Business::Website', foreign_key: :business_website_id, counter_cache: true
  belongs_to :owner,    class_name: 'People::User',  foreign_key: :owner_id, counter_cache: true
  
end