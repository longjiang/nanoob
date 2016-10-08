class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :init_menu, unless: :devise_controller?
  before_action :add_menu_items, unless: :devise_controller?
  before_action :menu_activate, unless: :devise_controller?
  before_action :set_locale
  
  around_action :set_time_zone
  
  include ApplicationHelper
  include Breadcrumbs::ActionController
  include IndexAddnewConcern
  include ShowEditConcern
  include EditCancelConcern
  
  rescue_from "AccessGranted::AccessDenied" do |exception|
    redirect_to root_path, alert: "You don't have permission to access this page.", status: 303
  end
  
  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end
    
    def init_menu
      @menu = Menu.new do |menu|
        %w(people/user business business/website partner partner/request partner/backlink blog/contents/post blog/contents/page).each do |item|
          if can? :list, item.camelize.constantize
            if current_user.last_filters[item.pluralize].blank?
              link_params = case item
              when 'blog/contents/post'
                {mine: current_user.id, business_id: current_user.business_id, business_website_id: current_user.website_id}
              else
                {owner: current_user.id, business_id: current_user.business_id, business_website_id: current_user.website_id}
              end
            else
              link_params = current_user.last_filters[item.pluralize]
            end
            menu.add I18n.t("menu.#{item.pluralize}"), send("#{item.pluralize.gsub(/\//, '_')}_path", link_params), item.camelize.constantize.model_name.element.pluralize, {icon: item.classify.constantize.decorator_class.icon}
          end
        end
      end
    end
    
    def menu_activate
      @menu.activate path: request.fullpath
    end
    
    def add_menu_items
    end
    
    def add_breadcrumbs
    end
    
  private

    def set_time_zone
      time_zone = current_user.try(:time_zone) || 'UTC'
      Time.use_zone(time_zone) { yield }
    end  
    
    def set_locale
      I18n.locale = :en
    end
    
end
