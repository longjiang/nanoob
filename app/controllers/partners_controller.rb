class PartnersController < CrudController
  self.permitted_attrs  = [:title, :category, :url, :contact_name, :contact_email, :webform_url, :user_id, :pending_request_id]
  self.filtering_params = [ :category, :starts_with, :contact, :recent, :inactive, :owner ]
  self.sortable_attrs   = [ :title, :category, :contact_name, :created_at ]
  
  def index
    super
    @partners_unsliced = @partners
    @partners = @partners.page(params[:page])
  end
  
  def edit
    @partner.pending_request_id = params[:pending_request_id] if params[:pending_request_id].present?
  end
  
  def update
    params[:partner].delete(:pending_request_id) if params[:commit].present?
    super do |format, updated|
      if updated
        if params[:send_request].present?
          @partner.pending_request.send_request 
        elsif params[:new_request].present?
          format.html { redirect_to new_partner_request_path(partner_id: @partner.id) }
        end
      end
    end
  end
  
  private
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.partners"), partners_path(owner: current_user.id), 'partners', {icon: Partner.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.partner.all"), partners_path, {icon: false}
        submenu.add I18n.t("menu.partner.add_new"), new_partner_path, {icon: false}
      end
    end
  end
  
end
