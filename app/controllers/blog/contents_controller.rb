class Blog::ContentsController < CrudController
  
  prepend_before_action :find_website
  prepend_before_action :find_business
  
  before_action :create_tags, only: [:create, :update]
  before_action :update_bodies, only: [:create, :update]
  before_action :default_users, only: [:new]
  before_action :default_status, only: [:new]
  before_action :default_website, only: [:new]
  before_action :add_breadcrumbs, except: [:index]
  
  prepend_before_action :nilify_published_at, only: [:create, :update]
  
  self.permitted_attrs = [:business_website_id, :owner_id, :editor_id, :optimizer_id, :writer_id, :title, :slug, :body, :body_was, :body_xs, :body_xs_was, :published_at, :featured_image, :remove_featured_image, {:category_ids => []}, {:tag_ids => []}]
  self.filtering_params = [ :owner, :editor, :writer, :optimizer, :mine, :status, :recent, :business_website_id, :title_contains, :published_after, :published_before, :category_id, :tag_id ]
  self.sortable_attrs   = [ :title, :status_date ]
  
  def create
    super do |format, created|
      if created
        if params[:submit_for_review].present?
          authorize! :submit, entry
          entry.submitted!
        end
        if params[:publish].present?
          authorize! :publish, entry
          entry.published!
        end
      end
    end
  end
  
  def update
    super do |format, updated|
      if updated  
        if params[:submit_for_review].present?
          authorize! :submit, entry
          entry.submitted! 
        end
        if params[:publish].present?
          authorize! :publish, entry
          entry.published! 
        end
        if params[:refuse].present?
          authorize! :refuse, entry
          entry.draft!
        end
        if params[:unpublish].present?
          authorize! :unpublish, entry
          entry.draft!
        end
      end
    end
  end
  
  private
  
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
  
  def default_website
    entry.website = @website unless entry.website
  end
  
  def default_status
    entry.status = :draft unless entry.status
  end
  
  def add_breadcrumbs
    if @business.nil?
      add_breadcrumb tmp(:business), businesses_path, icon: Business.decorator_class.icon
    else
      add_breadcrumb @business.decorate.name, business_path(@business)
    end

    with_link = true if action_name.eql?('show')
    if @website.nil?
      add_breadcrumb tmp('business/website'), business_websites_path, icon: Business::Website.decorator_class.icon
    else
      add_breadcrumb @website.decorate.host, business_website_path(@website), with_link: with_link
    end
  end
  
  def create_tags
    if model_params['tag_ids']
      tag_ids = []
      model_params['tag_ids'].each do |tag_id|
        if tag_id.to_i.to_s.eql?(tag_id)
          tag_ids << tag_id
        else
          tag = @website.tags.create(name: tag_id)
          tag_ids << tag.id
        end
      end
      params['blog_contents_post']['tag_ids'] = tag_ids
    end
  end
  
end