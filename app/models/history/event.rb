class History::Event < ApplicationRecord
  validates :name,        presence: true
  validates :description, presence: true
  has_many    :histories, foreign_key: :history_event_id, :dependent => :nullify
end
