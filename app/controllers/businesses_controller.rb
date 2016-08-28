class BusinessesController < CrudController
  self.permitted_attrs = [:name, :business_product_id, :language]
  
  before_action :add_breadcrumbs, except: [:index, :show]
  
  def index
    super
    @businesses = @businesses.includes(:product)
  end
  
  private 
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.businesses"), businesses_path(owner: current_user.id, business_id: current_user.business_id, business_website_id: current_user.website_id), 'businesses', {icon: Business.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.business.all"), businesses_path, {icon: false}
        submenu.add I18n.t("menu.business.add_new"), new_business_path, {icon: false}
      end
    end
  end
  
  def add_breadcrumbs
    add_breadcrumb tmp(:business), businesses_path, icon: Business.decorator_class.icon
    if @business.nil? || @business.name.blank?
      add_breadcrumb "#{t 'activerecord.actions.new'} #{tm :business}"
    else
      add_breadcrumb @business.name
    end
  end
  
  def new_object_path
    new_business_path
  end
  
end
