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
        menu.add "item1", "item1", root_path do |submenu|
          submenu.add "item11", "item11", root_path
          submenu.add "item12", "item12", root_path
        end
        menu.add "item2", "item2", root_path, {active: true} do |submenu|
          submenu.add "item13", "item13", root_path
          submenu.add "item14", "item14", root_path
        end
        menu.add "item3", "item3", root_path
      end
    end
end
