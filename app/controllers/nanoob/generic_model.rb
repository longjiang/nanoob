module Nanoob
  module GenericModel
    
    extend ActiveSupport::Concern
    
    # The ActiveRecord class of the model.
    def model_class
      @model_class ||= controller_path.classify.constantize
    end
    
    # The identifier of the model used for form parameters.
    # I.e., the symbol of the underscored model name.
    def model_identifier
      @model_identifier ||= controller_path.gsub(/\//, '_').singularize.to_sym
    end
    
    # A human readable plural name of the model.
    def models_label(plural = true)
      opts = { count: (plural ? 3 : 1) }
      opts[:default] = model_class.model_name.human.titleize
      opts[:default] = opts[:default].pluralize if plural
      model_class.model_name.human(opts)
    end
    
    def get_entries
      instance_variable_get(:"@#{object_name true}")
    end
    
    def set_entries
      instance_variable_set(:"@#{object_name true}", model_class.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params)))
    end
    
    def get_entry
      instance_variable_get(:"@#{object_name false}")
    end
    
    def set_entry
      _ = (params[:id] ? find_entry : build_entry)
      instance_variable_set(:"@#{object_name false}", _)
    end
    
    def build_entry
      model_class.new
    end
    
    def find_entry
      model_class.find params[:id]
    end
    
    def object_name(plural=false)
      if plural
        controller_name
      else
        controller_name.singularize
      end
    end
    
    # The path arguments to link to the given model entry.
    # If the controller is nested, this provides the required context.
    def path_args(last)
      last
    end
    
    def sortable_params
      sortable_attrs.map {|_| "#{Sortable::PREFIX}#{_.to_s}".to_sym} if sortable_attrs
    end
    
    
    
    
    class_methods do
      def all_params
        sortable_params.merge(filtering_params)
      end

    end
  
  end
end