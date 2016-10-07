require_relative 'item'
require_relative 'builder'

module Breadcrumbs

  module ActionController
    extend ActiveSupport::Concern

    included do |base|
      extend          ClassMethods
      helper          HelperMethods
      helper_method   :add_breadcrumb, :breadcrumb
      
      before_action do |controller|
        controller.send :breadcrumbs
      end
    end

    protected

    def add_breadcrumb(label, path = nil, options={})
      self.breadcrumbs << Breadcrumbs::Item.new(label, path, options)
    end

    def breadcrumbs
      @breadcrumbs ||= []
    end
    
    def breadcrumb
      @breadcrumb ||= Breadcrumbs::Builder.new 
    end

    module ClassMethods

       def add_breadcrumb(label, path = nil, options={})
         before_action do |controller|
           controller.send(:add_breadcrumb, label, path, options)
         end
       end

    end
    
    module HelperMethods
      def render_breadcrumbs
        breadcrumb.markup('item') do |label, path, options|
          render :partial => "breadcrumbs/item", :locals => { :label => label, :path => path, :options => options }
        end
        breadcrumb.markup('active_item') do |label, path, options|
          render :partial => "breadcrumbs/active_item", :locals => { :label => label, :path => path, :options => options }
        end
        breadcrumb.markup('container') do |items, options|
          render :partial => "breadcrumbs/container", :locals => { :items => items, :options => options}
        end
        breadcrumb.build(@breadcrumbs).html_safe
      end
      
    end

  end

end