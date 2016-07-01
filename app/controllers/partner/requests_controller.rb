class Partner::RequestsController < CrudController
  self.permitted_attrs = [:partner_id, :business_id, :subject, :body, :channel, :sent_at, :state, :user_id, :state_updated_by]
  
  before_action :find_business
  before_action :find_partner
  
  def index
    if @business
      @requests = @business.requests
    else
      super
    end
  end
  
  private
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.partner/requests"), partner_requests_path, {icon: Partner::Request.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.partner/request.all"), partner_requests_path, {icon: false}
        submenu.add I18n.t("menu.partner/request.add_new"), new_partner_request_path, {icon: false}
      end
    end
  end
  
  def find_business
    @business = if params[:business_id].present?
      Business.find_by_id(params[:business_id]) 
    elsif has_model_params?
      Business.find_by_id(model_params[:business_id]) 
    elsif @request && !@request.new_record?
      @request.business 
    end
  end
  
  def find_partner
    @partner = if params[:partner_id].present?
      Partner.find_by_id(params[:partner_id]) 
    elsif has_model_params?
      Partner.find_by_id(model_params[:partner_id]) 
    elsif @request && !@request.new_record?
      @request.partner 
    end
  end
  
  
end
