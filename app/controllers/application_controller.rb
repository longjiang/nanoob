class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :init_menu, unless: :devise_controller?
  before_action :add_menu_items, unless: :devise_controller?
  before_action :menu_activate, unless: :devise_controller?
  
  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end
    
    def init_menu
      @menu = Menu.new do |menu|
        %w(business business/website partner partner/request partner/backlink).each do |item|
          menu.add I18n.t("menu.#{item.pluralize}"), send("#{item.pluralize.gsub(/\//, '_')}_path"), {icon: item.classify.constantize.decorator_class.icon}
        end
      end
    end
    
    def menu_activate
      @menu.activate path: request.fullpath
    end
    
    def add_menu_items
    end
end
