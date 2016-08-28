module Nanoob::Meta extend ActiveSupport::Concern
  included do
    before_save :save_meta
    has_one :metum, as: :metaable, dependent: :destroy
    
    def datas
      #self.metum ||= Metum.new(object_class: self.class.name, object_id: self.id)
      self.metum || self.build_metum
    end
    
    def set_meta(key, value)
      datas.meta = datas.meta.merge({key => value})
    end

    def get_meta(key)
      datas.meta[key.to_s]
    end
    
    def save_meta
      if metum && metum.datas_changed? && !(metum.new_record? && metum.meta.blank?)
        self.metum.save!
      end
    end
    
  end
end