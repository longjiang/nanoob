class People::AuthorsController < PeopleController
  
  self.permitted_attrs  = [:username, :firstname, :lastname, :biography, :optimizer_id, :profile_image, :remove_profile_image]
  
  before_action :find_author, except: [:destroy, :show]
  
  def index
    authors
  end
  
  def destroy
    super do |format, destroyed|
      authors
      if destroyed
        format.js { render 'destroyed' }
      else
        @flash_danger = "Author not destroyed"
        format.js { render 'index' }
      end
      
    end
  end
  
  def create
    super do |format, created|
      authors
      if created 
         format.js { render 'created' }
      else
        @flash_danger = "Author not created"
        format.js { render 'new' }
      end
    end
  end
  
  def update
    super do |format, updated|
      authors
      if updated 
        @author = People::Author.new
        format.js { render 'updated' }
      else
        @flash_danger = "Author not updated"
        format.js { render 'edit' }
      end
    end
  end
  
  def show
    authors
  end
  
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
  
  def find_author
    @author = if params[:id].present?
      set_entry
    else
      People::Author.new
    end
  end
  
  def authors
    @authors = People::Author.order(:username).all.page(params[:page])
  end
  
end