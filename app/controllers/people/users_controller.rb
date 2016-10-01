class People::UsersController < PeopleController
  
  private
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.people/users"), people_users_path(owner: current_user.id), 'users', {icon: People::User.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.people/user.all"), people_users_path, {icon: false}
        submenu.add I18n.t("menu.people/user.add_new"), new_people_user_path, {icon: false}
      end
    end
  end
  
end
