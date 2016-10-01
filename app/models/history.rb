class History < ApplicationRecord
  
  include Storext.model
  
  before_create :timestamp!
  
  belongs_to :person
  belongs_to :event, optional: true, foreign_key: :history_event_id #TODO: event is not optional
  belongs_to :archivable, optional: true, polymorphic: true
  
  store_attributes :datas do
    comment String
    change_from Hash, default: {}
    change_to Hash, default: {}
    event String
  end
  
  scope :active, -> { where(valid_to: 'infinity') }
  
  
  
  private
  
  def timestamp!
    previous = History.active.where(archivable_type: archivable_type, archivable_id: archivable_id).first
    now = Time.now
    if previous
      previous.valid_to = now
      previous.save!
    end
    self.valid_from = now
    self.valid_to = 'infinity'
  end
  
end
