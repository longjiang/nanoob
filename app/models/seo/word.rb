class Seo::Word < ApplicationRecord
  
  REGEXP = /[\p{Alpha}\-']+/
  
  belongs_to :word_countable, polymorphic: true
  
  
end
