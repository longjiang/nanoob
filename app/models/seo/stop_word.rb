class Seo::StopWord < ApplicationRecord
  
  belongs_to :excludable, polymorphic: true
  
end
