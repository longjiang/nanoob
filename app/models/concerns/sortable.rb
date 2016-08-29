module Sortable
  
  extend ActiveSupport::Concern
  
  PREFIX = 'sort_by_'

  module ClassMethods
    
    def sort(sortable_params)
      results = self.where(nil)
      sortable_params.each do |key, value|
        if value.present?
          direction = value.eql?('desc') ? :desc : :asc
          if self.respond_to?(key.to_sym)
            results = results.send(key.to_sym, direction)
          else
            results = results.order(key.gsub(Sortable::PREFIX,'') => direction)
          end
        end
      end
      results
    end
  end
end