class BusinessesController < CrudController
  self.permitted_attrs = [:name, :business_product_id, :language]
  
  private 
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.businesses"), businesses_path, 'business', 'businesses', {icon: Business.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.business.all"), businesses_path, {icon: false}
        submenu.add I18n.t("menu.business.add_new"), new_business_path, {icon: false}
      end
    end
  end
  
end
