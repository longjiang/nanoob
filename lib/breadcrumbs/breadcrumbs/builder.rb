module Breadcrumbs
  class Builder
    def initialize
      @markup = {}
    end
    
    def markup(type, options={}, &block)
     @markup[type] = { :block => block, :options => options } 
    end
    
    def build(items)
      return '' if items.blank?
      output = ''
      items.each_with_index do |item, idx|
        is_active = idx.eql?(items.size - 1)
        options = {}
        output += @markup[is_active ? 'active_item' : 'item'][:block].call(item.label, item.path, options)
      end
      @markup['container'][:block].call(output, {})
    end
  end
end