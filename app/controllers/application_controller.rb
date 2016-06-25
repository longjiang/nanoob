class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :init_menu, unless: :devise_controller?
  
  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end
    
    def init_menu
      @menu = Menu.new do |menu|
        menu.add "Businesses", businesses_path do |submenu|
          submenu.add "Websites", business_websites_path
        end
      end
    end
end
