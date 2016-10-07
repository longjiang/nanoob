class Business::Language < ApplicationRecord
  
  validates :name,     presence: true
  
  has_many  :businesses , foreign_key: :business_language_id, :dependent => :nullify
  has_many  :stop_words , class_name: 'Seo::StopWord' , as: :excludable, dependent: :delete_all
  
end
