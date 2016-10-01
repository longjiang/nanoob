class Person < ApplicationRecord

  attachment :profile_image, type: :image
  
  include Storext.model
         
  validates :username, presence: true
  validates :username, uniqueness: true
  
  store_attributes :meta do
    #subscribed_to_newsletter Boolean, default: false
    firstname String
    lastname String
  end
  
end