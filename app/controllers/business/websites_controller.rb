class Business::WebsitesController < CrudController
  
  self.permitted_attrs = [:platform, :url, :business_id]
  
  before_action :find_business
  
  def index
    
    add_breadcrumb 'myname', '/mypath'
    if @business
      @websites = @business.websites
    else
      super
    end
  end
  
  private
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.business/websites"), business_websites_path(owner: current_user.id), 'websites', {icon: Business::Website.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.business/website.all"), business_websites_path, {icon: false}
        submenu.add I18n.t("menu.business/website.add_new"), new_business_website_path, {icon: false}
      end
    end
  end
  
  def find_business
    @business = if params[:business_id].present?
      Business.find_by_id(params[:business_id]) 
    elsif has_model_params?
      Business.find_by_id(model_params[:business_id]) 
    elsif @website && !@website.new_record?
      @website.business 
    end
  end
  
end
