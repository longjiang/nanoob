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
    
    def meta_accessor(*args)
      args.each do |arg|
        getter arg 
        setter arg
      end
    end
    
    def meta_reader(*args)
      args.each { |arg| getter arg }
    end
    
    def meta_writer(*args)
      args.each { |arg| setter arg }
    end
    
    private
    
    def getter(arg)
      define_method :"#{arg.to_s}", -> { get_meta(arg) }
    end
    
    def setter(arg)
      define_method :"#{arg.to_s}=", -> (val) { set_meta(arg, val) } 
    end
    
  end
  
end