module Breadcrumbs
  class Item
    
    # @return [String] The element/link label.
    attr_accessor :label
    # @return [String] The element/link URL.
    attr_accessor :path
    # @return [Hash] The element/link URL.
    attr_accessor :options

    # Initializes the Element with given parameters.
    #
    # @param  [String] label The element/link label.
    # @param  [String] path The element/link URL.
    # @param  [Hash] options The element/link URL.
    # @return [Element]
    #
    def initialize(label, path = nil, options = {})
      self.label    = label
      self.path     = path
      self.options  = options
    end
    
  end
end