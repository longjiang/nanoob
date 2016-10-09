class Seo::Anchor < ApplicationRecord
  belongs_to :link, class_name: 'Seo::Link', foreign_key: 'seo_link_id', counter_cache: true
  belongs_to :content, class_name: 'Blog::Content', foreign_key: 'blog_content_id', counter_cache: true
  delegate :url, to: :link
  delegate :host, to: :link
end
