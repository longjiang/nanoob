class Metum < ApplicationRecord
  
  include Storext.model
  
  #validations 
  
  store_attributes :datas do
    statistics Hash, default: {}
  end
  
end
