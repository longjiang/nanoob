module Nanoob::History extend ActiveSupport::Concern
  included do
    has_many :histories, ->(object){where(object_class: object.class.to_s.gsub("Decorator",""))}, :class_name => "History", foreign_key: :object_id, dependent: :destroy
  end
  
  def add_to_history(change_from, change_to, comment, user=nil)
    histories.create!(change_from: change_from, change_to: change_to, comment: comment, user_id: user.try(:id))
  end
  
  def last_history
    histories.active.first
  end
end