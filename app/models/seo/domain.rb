class Seo::Domain < ApplicationRecord
  
  enum category: [ :uncategorized, :social_network, :blog, :news, :reference, :shopping ]
  
  has_many :links, class_name: 'Seo::Link', foreign_key: 'seo_domain_id'
  
end
