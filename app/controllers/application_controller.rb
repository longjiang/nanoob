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
        menu.add I18n.t("menu.businesses"), businesses_path, {icon: 'industry'}
        menu.add I18n.t("menu.websites"), business_websites_path, {icon: 'globe'}
        menu.add I18n.t("menu.partners"), partners_path, {icon: 'users'}
        menu.add I18n.t("menu.requests"), partner_requests_path, {icon: 'file-text'}
        menu.add I18n.t("menu.backlinks"), partner_backlinks_path, {icon: 'link'}
      end
    end
    
    def menu_activate
      @menu.activate path: request.fullpath
    end
    
    def add_menu_items
      
    end
end
