class Seo::Host < ApplicationRecord
  
  enum category: [ :uncategorized, :social_network, :blog, :news, :reference, :shopping ]
  
  has_many :links, class_name: 'Seo::Link', foreign_key: 'seo_host_id'
  has_many :host_categorizations, class_name: 'Seo::HostCategorization', foreign_key: 'seo_host_id'
  has_many :businesses, through: :host_categorizations
  
end
