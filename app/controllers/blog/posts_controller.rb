class Blog::PostsController < CrudController
  
  self.permitted_attrs = [:business_website_id, :owner_id, :title, :slug, :body, :body_was, :body_xs, :body_xs_was, :published_at, :featured_image, :remove_featured_image, {:category_ids => []}]
  self.filtering_params = [ :owner, :status, :recent, :business_website_id, :title_contains, :published_after, :published_before, :category_id  ]
  self.sortable_attrs   = [ :title, :status_date ]
  
  prepend_before_action :find_website
  prepend_before_action :find_business
  before_action :update_bodies, only: [:create, :update]
  before_action :default_user, only: [:new]
  before_action :default_website, only: [:new]
  before_action :add_breadcrumbs, except: [:index]
  before_action :nilify_published_at, only: [:create, :update]
  
  def create
    super do |format, created|
      if created && params[:publish].present?
        @post.published!
      end
    end
  end
  
  def update
    super do |format, updated|
      if updated  
        @post.draft! if params[:unpublish].present?
        @post.published! if params[:publish].present?
      end
    end
  end
  
  def index
    super
    @posts = @posts.includes(:owner).includes(:metum)
    @posts = @posts.includes(:categories) unless params[:category_id]
    @posts = @posts.includes(:website) unless @website
    @posts_unpaginated = @posts
    @posts = @posts.page(params[:page])
    @posts_not_status_filtered = Blog::Post.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params - [:status, :published_after, :published_before]))
    @posts_not_owner_filtered = Blog::Post.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params - [:owner]))
  end
  
  
  private
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.blog/posts"), blog_posts_path(owner: current_user.id, business_id: current_user.business_id, business_website_id: current_user.website_id), 'posts', {icon: Blog::Post.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.blog/post.all"), blog_posts_path, {icon: false}
        submenu.add I18n.t("menu.blog/post.add_new"), new_blog_post_path(business_website_id: current_user.website_id), {icon: false}
        submenu.add I18n.t("menu.blog/categories.all"), blog_categories_path(business_website_id: @website ? @website.id : current_user.website_id), {icon: false}
      end
    end
  end
  
  def find_website
    @website = if params[:business_website_id].present?
      Business::Website.find_by_id(params[:business_website_id])
    elsif has_model_params?
      Business::Website.find_by_id(model_params[:business_website_id])
    #elsif params[:category_id].present?
      #Blog::Category.find(params[:category_id]).website
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
  
  def default_website
    @post.website = @website unless @post.website
  end
  
  def nilify_published_at
    (1..5).each {|i| params[:blog_post].delete("published_at(#{i}i)")} if params[:blog_post].delete(:publish_now)
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
    new_blog_post_path(business_website_id: @website.try(:id))
  end
  
end