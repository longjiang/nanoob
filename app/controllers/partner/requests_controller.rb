class Partner::RequestsController < CrudController
  self.permitted_attrs = [:partner_id, :business_id, :subject, :body, :body_was, :body_xs, :body_xs_was, :channel, :sent_at, :state, :user_id, :state_updated_by, :bootsy_image_gallery_id]
  self.filtering_params = [ :channel, :owner, :state, :recent, :business_id  ]
  
  before_action :find_business
  before_action :find_partner
  before_action :default_user, only: [:new]
  before_action :update_bodies, only: [:create, :update]
  before_action :add_breadcrumbs, except: [:index]
  
  def index
    super
    @requests = @requests.includes(:owner).includes(:backlink)
    @requests = @requests.includes(:partner) unless @partner
    @requests = @requests.includes(:business) unless @business
    @requests_unpaginated = @requests
    @requests = @requests.page(params[:page])
    @requests_not_owner_filtered = Partner::Request.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params - [:owner]))
  end
  
  
  
  
  
  def edit
    #respond_to do |format|
      unless @request.draft?
        flash[:alert] = "Request is not editable"
        redirect_on_failure({location: partner_request_path(@request)})
        #format.html { redirect_on_failure({location: partner_request_path(@request)}) }
        #format.json { render json: entry.errors, status: :unprocessable_entity }
      end
    #end
  end
  
  def create
    super do |format, created|
      if created && params[:send_request].present?
        send_request(format, :new)
      end
    end
  end
  
  def update
    super do |format, updated|
      if updated && params[:send_request].present?
        send_request(format, :edit)
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
  
  def send_request(format, action)
    if !@request.form_completed?
      [:channel, :subject, :body_xs].each do |att|
        @request.errors[att] << "Can't be blank" if @request.send(att).blank?
      end
      flash[:alert] = "Request saved but can't be sent"
      format.html { render action }
      format.json { render json: entry.errors, status: :unprocessable_entity }
    elsif !@request.sendable?
      flash[:alert] = "Request saved but can't be sent because partner informations are not valid"
      format.html { redirect_to edit_partner_path(@request.partner, {pending_request_id: @request.id}) }
      format.json { render json: entry.errors, status: :unprocessable_entity }
    else
      begin
        @request.send_request
        flash[:notice] = "Request has been sent"
        format.html { redirect_to show_path }
        format.json { render json: entry.errors, status: :unprocessable_entity }
      rescue AASM::InvalidTransition
        flash[:alert] = "Request saved but can't be sent for now"
        format.html { redirect_to show_path }
        format.json { render json: entry.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def add_breadcrumbs
    if @business.nil?
      add_breadcrumb tmp(:business), businesses_path, icon: Partner::Backlink.decorator_class.icon
    else
      add_breadcrumb @business.decorate.name, business_path(@business)
    end
  
    if @partner.nil?
      add_breadcrumb tmp(:partner), partners_path, icon: Partner.decorator_class.icon
    else
      add_breadcrumb @partner.decorate.name, partner_path(@partner)
    end
  
    if @request.nil? || @request.id.blank?
      add_breadcrumb "#{t 'activerecord.actions.new'} #{tm 'partner/request'}"
    else
      add_breadcrumb @request.decorate.name
    end
  end
  
  def new_object_path
    new_partner_request_path
  end
  
end
