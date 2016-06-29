
class Business < ApplicationRecord
  
  enum language: [ :french, :english, :italian ]
  
  validates :name,                presence: true
  validates :business_product_id, presence: true
  validates :language,            presence: true
  
  has_many    :websites,   dependent: :destroy
  has_many    :requests,   dependent: :destroy,  class_name: 'Partner::Request'
  has_many    :backlinks,  dependent: :destroy,  class_name: 'Partner::Backlink'
  belongs_to  :product,                          class_name: 'Business::Product', foreign_key: :business_product_id
  
  delegate :name, to: :product, prefix: true
  
  
  
end

