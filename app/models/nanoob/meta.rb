module Nanoob::Meta extend ActiveSupport::Concern
  
  included do
    
    extend         ClassMethods
    
    before_save :save_meta
    has_one :metum, as: :metaable, dependent: :destroy
    
    def datas
      self.metum || self.build_metum
    end
    
    def set_meta(key, value)
      key = key.to_s
      instance_variable_set(:"@meta_#{key}", value)
      datas.meta = datas.meta.merge({key => value})
    end

    def get_meta(key)
      key = key.to_s
      instance_variable_get(:"@meta_#{key}") || instance_variable_set(:"@meta_#{key}", datas.meta[key])
    end
    
    def save_meta
      if metum && metum.datas_changed? && !(metum.new_record? && metum.meta.blank?)
        self.metum.save!
      end
    end
    
  end
  
  module ClassMethods
    
    def has_meta(*args)
      args.each do |arg|
        define_method :"#{arg.to_s}", -> { get_meta(arg) }
        define_method :"#{arg.to_s}=", -> (val) { set_meta(arg, val) } 
      end
    end
  end
  
end