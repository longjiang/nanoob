class People::AuthorsController < PeopleController
  
  private 
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.business/websites"), business_websites_path(owner: current_user.id, business_id: current_user.business_id, business_website_id: current_user.website_id), 'websites', {icon: Business::Website.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.business/website.all"), business_websites_path, {icon: false}
        submenu.add I18n.t("menu.business/website.add_new"), new_business_website_path, {icon: false}
        submenu.add I18n.t("menu.people/author.all"), people_authors_path, {icon: false}
      end
    end
  end
  
end