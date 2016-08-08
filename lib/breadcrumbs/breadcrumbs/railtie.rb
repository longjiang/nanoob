require_relative 'action_controller'

module Breadcrumbs
  class Railtie < Rails::Railtie
    ActiveSupport.on_load(:action_controller) do
      include Breadcrumbs::ActionController
    end
  end
end
  
  