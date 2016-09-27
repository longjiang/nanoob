class Blog::Contents::PagesController < Blog::ContentsController
  
  def index
    super
    @pages = @pages.includes(:owner).includes(:metum)
    @pages = @pages.includes(:categories) unless params[:category_id]
    @pages = @pages.includes(:website) unless @website
    @pages_unpaginated = @pages
    @pages = @pages.page(params[:page])
    @pages_not_status_filtered = Blog::Contents::Page.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params - [:status, :published_after, :published_before]))
    @pages_not_owner_filtered = Blog::Contents::Page.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params - [:owner]))
  end
  
  private
  
  def update_bodies
    p = params[:blog_page]
    p[:body]    = p[:body_xs] unless p[:body_xs].eql?(p.delete(:body_xs_was))
    p[:body_xs] = p[:body]    unless p[:body].eql?(p.delete(:body_was)) 
  end
  
  def nilify_published_at
    (1..5).each {|i| params[:blog_page].delete("published_at(#{i}i)")} if params[:blog_page].delete(:publish_now)
  end
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.blog/contents/pages"), blog_contents_pages_path(owner: current_user.id, business_id: current_user.business_id, business_website_id: current_user.website_id), 'pages', {icon: Blog::Contents::Page.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.blog/contents/page.all"), blog_contents_pages_path, {icon: false}
        submenu.add I18n.t("menu.blog/contents/page.add_new"), new_blog_contents_page_path(business_website_id: current_user.website_id), {icon: false}
      end
    end
  end
  
  def new_object_path
    new_blog_contents_page_path(business_website_id: @website.try(:id))
  end
  
end