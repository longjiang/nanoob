module Nanoob::History extend ActiveSupport::Concern
  included do
    #has_many :histories, ->(object){where(object_class: object.class.to_s.gsub("Decorator",""))}, :class_name => "History", foreign_key: :object_id, dependent: :destroy
    has_many :histories, as: :archivable, dependent: :destroy
  end
  
  def add_to_history(change_from, change_to, comment, person=nil)
    histories.create!(change_from: change_from, change_to: change_to, comment: comment, person_id: person.try(:id))
  end
  
  def last_history
    histories.active.first
  end
end