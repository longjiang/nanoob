class Partner::RequestsController < CrudController
  self.permitted_attrs = [:partner_id, :business_id, :subject, :body, :body_was, :body_xs, :body_xs_was, :channel, :sent_at, :state, :user_id, :state_updated_by, :bootsy_image_gallery_id]
  self.filtering_params = [ :channel, :owner, :state, :recent, :business_id  ]
  
  before_action :find_business
  before_action :find_partner
  before_action :default_user, only: [:new]
  before_action :update_bodies, only: [:create, :update]
  
  def index
    super
    @requests = @requests.includes(:owner).includes(:backlink)
    @requests = @requests.includes(:partner) unless @partner
    @requests = @requests.includes(:business) unless @business
    @requests_unsliced = @requests
    @requests = @requests.page(params[:page])
  end
  
  def create
    super
    send_request if params[:send_request].present?
  end
  
  def update
    super do |format, updated|
      if updated && params[:send_request].present?
        send_request(format)
      end
    end
  end
  
  private
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.partner/requests"), partner_requests_path(owner: current_user.id, business_id: current_user.business_id), 'requests', {icon: Partner::Request.decorator_class.icon} do |submenu|
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
  
  def update_bodies
    p = params[:partner_request]
    p[:body]    = p[:body_xs] unless p[:body_xs].eql?(p.delete(:body_xs_was))
    p[:body_xs] = p[:body]    unless p[:body].eql?(p.delete(:body_was)) 
  end
  
  def default_user
    @request.owner = current_user unless @request.owner 
  end
  
  def send_request(format)
    begin
      @request.send_request
    rescue AASM::InvalidTransition
      format.html { render :new }
    end
  end
  
end
