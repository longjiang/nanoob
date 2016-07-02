class Partner::BacklinksController < CrudController
  self.permitted_attrs = [:partner_id, :business_id, :partner_request_id, :user_id, :referrer, :anchor, :link]
  before_action :find_business
  before_action :find_partner
  
  private
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.partner/backlinks"), partner_backlinks_path, {icon: Partner::Request.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.partner/backlink.all"), partner_backlinks_path, {icon: false}
        submenu.add I18n.t("menu.partner/backlink.add_new"), new_partner_backlink_path, {icon: false}
      end
    end
  end
  
  def find_business
    @business = if params[:business_id].present?
      Business.find_by_id(params[:business_id]) 
    elsif has_model_params?
      Business.find_by_id(model_params[:business_id]) 
    elsif @backlink && !@backlink.new_record?
      @backlink.business 
    end
  end
  
  def find_partner
    @partner = if params[:partner_id].present?
      Partner.find_by_id(params[:partner_id]) 
    elsif has_model_params?
      Partner.find_by_id(model_params[:partner_id]) 
    elsif @backlink && !@backlink.new_record?
      @backlink.partner 
    end
  end
  
end
