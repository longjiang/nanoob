module ContentsConcern
  extend ActiveSupport::Concern

  included do
    extend         ClassMethods
    helper         HelperMethods
    
    prepend_before_action :find_website
    prepend_before_action :find_business
    before_action :create_tags, only: [:create, :update]
    before_action :update_bodies, only: [:create, :update]
    before_action :default_user, only: [:new]
    before_action :default_website, only: [:new]
    before_action :add_breadcrumbs, except: [:index]
    before_action :nilify_published_at, only: [:create, :update]
    
    self.permitted_attrs = [:business_website_id, :owner_id, :title, :slug, :body, :body_was, :body_xs, :body_xs_was, :published_at, :featured_image, :remove_featured_image, {:category_ids => []}, {:tag_ids => []}]
    self.filtering_params = [ :owner, :status, :recent, :business_website_id, :title_contains, :published_after, :published_before, :category_id, :tag_id ]
    self.sortable_attrs   = [ :title, :status_date ]
    
  end
  
  
  
  def create
    super do |format, created|
      if created && params[:publish].present?
        entry.published!
      end
    end
  end
  
  def update
    super do |format, updated|
      if updated  
        entry.draft! if params[:unpublish].present?
        entry.published! if params[:publish].present?
      end
    end
  end
  
  protected
  
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
  
  def find_website
    @website = if params[:business_website_id].present?
      Business::Website.find_by_id(params[:business_website_id])
    elsif has_model_params?
      Business::Website.find_by_id(model_params[:business_website_id])
    #elsif params[:category_id].present?
      #Blog::Category.find(params[:category_id]).website
    elsif entry && !entry.new_record?
      entry.website 
    end
  end
  
  def default_user
    entry.owner = current_user unless entry.owner 
  end
  
  def default_website
    entry.website = @website unless entry.website
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
  
  def create_tags
    tag_ids = []
    model_params['tag_ids'].each do |tag_id|
      if tag_id.to_i.to_s.eql?(tag_id)
        tag_ids << tag_id
      else
        tag = @website.tags.create(name: tag_id)
        tag_ids << tag.id
      end
    end
    params['blog_post']['tag_ids'] = tag_ids
  end

  
   module ClassMethods
     
     
     
     
   end
   
   module HelperMethods
   end
end