class Seo::HostCategorization < ApplicationRecord
  
  enum category: [ :internal, :network, :other ]
  
   belongs_to   :host,  class_name: 'Seo::Host', foreign_key: 'seo_host_id'
   belongs_to   :business, class_name: 'Business'
  
end