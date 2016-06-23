class Business::Website < ApplicationRecord
  
  enum platform: [ :wordpress, :blogger ]
  
  validates :platform,     presence: true
  validates :url,          presence: true
  validates :url,          uniqueness: { scope: :business }
  validates :url,          url: true
  
  belongs_to :business
end
