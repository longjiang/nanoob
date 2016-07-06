module Nanoob::Meta extend ActiveSupport::Concern
  included do
    has_many :metum, ->(object){where(object_class: object.class.to_s.gsub("Decorator",""))}, :class_name => "Metum", foreign_key: :object_id, dependent: :destroy
  end
end