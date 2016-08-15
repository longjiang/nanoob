class Partner::BacklinksController < CrudController
  self.permitted_attrs = [:partner_id, :business_id, :partner_request_id, :user_id, :referrer, :anchor, :link]
  self.filtering_params = [ :owner, :status, :recent, :business_id ]
  
  before_action :find_request
  before_action :find_business
  before_action :find_partner
  before_action :add_breadcrumbs, except: [:index]
  
  def index
    super
    @backlinks_unpaginated = @backlinks
    @backlinks = @backlinks.includes(:partner).includes(:owner)
    @backlinks = @backlinks.page(params[:page])
    @backlinks_not_owner_filtered = Partner::Backlink.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params - [:owner]))
    
  end
  
  private
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.partner/backlinks"), partner_backlinks_path(owner: current_user.id, business_id: current_user.business_id), 'backlinks', {icon: Partner::Backlink.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.partner/backlink.all"), partner_backlinks_path, {icon: false}
        submenu.add I18n.t("menu.partner/backlink.add_new"), new_partner_backlink_path, {icon: false}
      end
    end
  end
  
  def find_business
    @business = if @request
      Business.find_by_id(@request.business_id) 
    elsif params[:business_id].present?
      Business.find_by_id(params[:business_id]) 
    elsif has_model_params?
      Business.find_by_id(model_params[:business_id]) 
    elsif @backlink && !@backlink.new_record?
      @backlink.business
    end
  end
  
  def find_partner
    @partner = if @request
      Partner.find_by_id(@request.partner_id) 
    elsif params[:partner_id].present?
      Partner.find_by_id(params[:partner_id]) 
    elsif has_model_params?
      Partner.find_by_id(model_params[:partner_id]) 
    elsif @backlink && !@backlink.new_record?
      @backlink.partner        
    end
  end
  
  def find_request
    @request = if params[:partner_request_id].present?
      Partner::Request.find_by_id(params[:partner_request_id])
    elsif has_model_params?
      Partner::Request.find_by_id(model_params[:partner_request_id])
    elsif @backlink && !@backlink.new_record?
      @backlink.request 
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
    unless @request.nil?
      add_breadcrumb @request.decorate.name, partner_request_path(@request)
    end
    if @backlink.nil? || @backlink.id.blank?
      add_breadcrumb "#{t 'activerecord.actions.new'} #{tm 'partner/backlink'}"
    else
      add_breadcrumb @backlink.decorate.name
    end
  end
  
  def new_object_path
    new_partner_backlink_path
  end
  
end
