class Blog::PostsController < CrudController
  
  self.permitted_attrs = [:business_website_id, :user_id, :title, :slug, :body, :body_was, :body_xs, :body_xs_was, :published_at, :featured_image, :remove_featured_image]
  self.filtering_params = [ :owner, :status, :recent, :business_website_id, :title_contains, :published_after, :published_before  ]
  self.sortable_attrs   = [ :title, :status_date ]
  
  before_action :find_website
  before_action :find_business
  before_action :update_bodies, only: [:create, :update]
  before_action :default_user, only: [:new]
  before_action :add_breadcrumbs, except: [:index]
  
  def index
    super
    @posts = @posts.includes(:owner).includes(:metum)
    @posts = @posts.includes(:website) unless @website
    @posts_unpaginated = @posts
    @posts = @posts.page(params[:page])
    @posts_not_status_filtered = Blog::Post.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params - [:status, :published_after, :published_before]))
    @posts_not_owner_filtered = Blog::Post.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params - [:owner]))
  end
  
  
  private
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.blog/posts"), blog_posts_path(website_id: current_user.website_id), 'blog/posts', {icon: Blog::Post.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.blog/post.all"), blog_posts_path, {icon: false}
        submenu.add I18n.t("menu.blog/post.add_new"), new_blog_post_path(website_id: current_user.website_id), {icon: false}
      end
    end
  end
  
  def find_website
    @website = if params[:business_website_id].present?
      Business::Website.find_by_id(params[:business_website_id])
    elsif has_model_params?
      Business::Website.find_by_id(model_params[:business_website_id])
    elsif @post && !@post.new_record?
      @post.website 
    end
  end
  
  def find_business
    @business = if @website
      @website.business 
    elsif params[:business_id].present?
      Business.find_by_id(params[:business_id]) 
    elsif has_model_params?
      Business.find_by_id(model_params[:business_id]) 
    elsif @backlink && !@backlink.new_record?
      @backlink.business
    end
  end
  
  def update_bodies
    p = params[:blog_post]
    p[:body]    = p[:body_xs] unless p[:body_xs].eql?(p.delete(:body_xs_was))
    p[:body_xs] = p[:body]    unless p[:body].eql?(p.delete(:body_was)) 
  end
  
  def default_user
    @post.owner = current_user unless @post.owner 
  end
  
  def add_breadcrumbs
    if @business.nil?
      add_breadcrumb tmp(:business), businesses_path, icon: Partner::Backlink.decorator_class.icon
    else
      add_breadcrumb @business.decorate.name, business_path(@business)
    end
  
    if @website.nil?
      add_breadcrumb tmp('business/website'), business_websites_path, icon: Business::Website.decorator_class.icon
    else
      add_breadcrumb @website.decorate.host, business_website_path(@website)
    end

  end
  
  def new_object_path
    new_blog_post_path(website: @website.try(:id))
  end
  
end