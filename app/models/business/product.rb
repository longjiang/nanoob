class Business::Product < ApplicationRecord
    
  validates :name,     presence: true
  
  has_many    :businesses, foreign_key: :business_product_id, :dependent => :nullify
  

end
