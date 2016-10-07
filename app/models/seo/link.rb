class Seo::Link < ApplicationRecord
  
  enum level: [ :internal, :network, :other ]
  
  belongs_to  :domain,  class_name: 'Seo::Domain', foreign_key: 'seo_domain_id', counter_cache: true
  has_many    :anchors, class_name: 'Seo::Anchor', foreign_key: 'seo_link_id'
end
