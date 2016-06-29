
class Business < ApplicationRecord
  
  enum language: [ :french, :english, :italian ]
  
  validates :name,          presence: true
  validates :product_line,  presence: true
  validates :language,      presence: true
  
  has_many :websites,   dependent: :destroy
  has_many :requests,   dependent: :destroy,  class_name: 'Partner::Request'
  has_many :backlinks,  dependent: :destroy,  class_name: 'Partner::Backlink'
  
end

