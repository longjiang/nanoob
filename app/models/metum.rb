class Metum < ApplicationRecord
  
  include Storext.model
  
  belongs_to :metaable, optional: true, polymorphic: true
  
  validates :metaable_id, uniqueness: { scope: :metaable_type}
  
  store_attributes :datas do
    meta Hash, default: {}
  end
  
end
