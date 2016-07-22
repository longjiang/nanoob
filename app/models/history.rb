class History < ApplicationRecord
  
  include Storext.model
  
  before_create :timestamp!
  
  belongs_to :user
  
  store_attributes :datas do
    comment String
    change_from Hash, default: {}
    change_to Hash, default: {}
    event String
  end
  
  scope :active, -> { where(valid_to: 'infinity') }
  
  
  
  private
  
  def timestamp!
    previous = History.active.where(object_class: object_class, object_id: object_id).first
    now = Time.now
    if previous
      previous.valid_to = now
      previous.save!
    end
    self.valid_from = now
    self.valid_to = 'infinity'
  end
  
end
