class PartnersController < CrudController
  self.permitted_attrs  = [:title, :category, :url, :contact_name, :contact_email, :webform_url, :user_id]
  self.filtering_params = [ :category, :starts_with, :contact, :recent, :inactive, :owner ]
  self.sortable_attrs   = [ :title, :category, :contact_name, :created_at ]
  
  private
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.partners"), partners_path, 'partners', {icon: Partner.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.partner.all"), partners_path, {icon: false}
        submenu.add I18n.t("menu.partner.add_new"), new_partner_path, {icon: false}
      end
    end
  end
  
end
