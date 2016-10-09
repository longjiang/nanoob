class Seo::Link < ApplicationRecord
  
  belongs_to  :host,  class_name: 'Seo::Host', foreign_key: 'seo_host_id', counter_cache: true
  has_many    :anchors, class_name: 'Seo::Anchor', foreign_key: 'seo_link_id'
end
