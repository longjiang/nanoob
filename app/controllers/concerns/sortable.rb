module Sortable
  
  extend ActiveSupport::Concern
  
  PREFIX = 'sort_by_'

  module ClassMethods
    
    def sort(sortable_params)
      results = self.where(nil)
      sortable_params.each do |key, value|
        if value.present?
          direction = value.eql?('desc') ? :desc : :asc
          results = results.order(key.gsub(Sortable::PREFIX,'') => direction)
        end
      end
      results
    end
  end
end