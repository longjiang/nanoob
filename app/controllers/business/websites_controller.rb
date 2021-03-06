class Business::WebsitesController < CrudController
  
  self.permitted_attrs = [:platform, :url, :business_id, :title, :baseline, :theme, :owner_id, :author_id, :woopra, :page_title_template]
  
  before_action :find_business
  before_action :add_breadcrumbs
  before_action :owner, only: [:new]
 
  def index
    if @business
      @websites = @business.websites
    else
      super
      @websites = @websites.includes(:business)
    end
  end
  
  def show
    if @website.nanoob?
      @deck = Dashboard::Deck.new(template: 'one') do |deck|
      
        deck.add cssclass: 'success', 
                 icon: Blog::Contents::Post.decorator_class.icon, 
                 count: @website.posts.published.published_before(Time.now).size, 
                 label: "#{hen('blog/contents/post', :status, :published)} #{tmp('blog/contents/post')}", 
                 path: blog_contents_posts_path(business_website_id: @website.id, status: :published, published_before: Time.now) if can? :list, Blog::Contents::Post
               
       deck.add cssclass: 'danger',
                icon: 'calendar',
                count: @website.posts.published.published_after(30.days.ago).published_before(Time.now).size,
                label: "Last 30 days",
                path: blog_contents_posts_path(business_website_id: @website.id, status: :published, published_after: 30.days.ago) if can? :list, Blog::Contents::Post
           
        deck.add cssclass: 'warning', 
                 icon: Blog::Contents::Post.decorator_class::STATUS_ICON_OPTIONS[:scheduled], 
                 count: @website.posts.published.published_after(Time.now).size, 
                 label: "#{hen('blog/contents/post', :status, :scheduled)} #{tmp('blog/contents/post')}", 
                 path: blog_contents_posts_path(business_website_id: @website.id, status: :published, published_after: Time.now) if can? :list, Blog::Contents::Post
               
       deck.add cssclass: 'primary', 
                icon: Partner::Backlink.decorator_class.icon, 
                count: @website.backlinks.size, 
                label: "#{tmp('partner/backlink')}", 
                path: partner_backlinks_path(business_website_id: @website.id) if can? :list, Partner::Backlink
      end
    end
  end
  
  private
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.business/websites"), business_websites_path(owner: current_user.id, business_id: current_user.business_id, business_website_id: current_user.website_id), 'websites', {icon: Business::Website.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.business/website.all"), business_websites_path, {icon: false}
        submenu.add I18n.t("menu.business/website.add_new"), new_business_website_path, {icon: false} if can? :create, Business::Website
        submenu.add I18n.t("menu.people/author.all"), people_authors_path, {icon: false}
      end
    end
  end
  
  def find_business
    @business = if params[:business_id].present?
      Business.find_by_id(params[:business_id]) 
    elsif has_model_params?
      Business.find_by_id(model_params[:business_id]) 
    elsif @website && !@website.new_record?
      @website.business 
    end
  end
  
  def add_breadcrumbs
    add_breadcrumb @business.decorate.name, business_websites_path(business_id: @business.id) unless @business.nil?
    unless action_name.to_sym.eql?(:index)
      if @website.nil? || @website.url.blank?
        add_breadcrumb tmp('business/website'), business_websites_path, icon: Business::Website.decorator_class.icon if @business.nil?
        add_breadcrumb "#{t 'activerecord.actions.new'} #{tm 'business/website'}"
      else
        add_breadcrumb @website.decorate.name 
      end
    end
  end
  
  def new_object_path
    new_business_website_path(business_id: @business)
  end
  
  def owner
    entry.owner_id = current_user.id if entry.owner_id.blank? 
  end
  
end
