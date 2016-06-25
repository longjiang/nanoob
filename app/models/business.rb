
class Business < ApplicationRecord
  
  enum language: [ :french, :english, :italian ]
  
  validates :name,          presence: true
  validates :product_line,  presence: true
  validates :language,      presence: true
  
  has_many :websites, dependent: :destroy
  
end

