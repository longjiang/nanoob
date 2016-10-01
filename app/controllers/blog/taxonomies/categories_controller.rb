class Blog::Taxonomies::CategoriesController < Blog::TaxonomiesController
  
  before_action :find_category, except: [:destroy, :show]
  
  def index
    categories
  end
  
  def update
    super do |format, updated|
      categories
      if updated 
        @category = Blog::Taxonomies::Category.new(website: @website)
        format.js { render 'updated' }
      else
        @flash_danger = "Category not updated"
        format.js { render 'edit' }
      end
    end
  end
  
  def create
    super do |format, created|
      categories
      if created 
         format.js { render 'created' }
      else
        @flash_danger = "Category not created"
        format.js { render 'new' }
      end
    end
  end
  
  def destroy
    super do |format, destroyed|
      categories
      if destroyed
        format.js { render 'destroyed' }
      else
        @flash_danger = "Category not destroyed"
        format.js { render 'index' }
      end
      
    end
  end
  
  def show
    # after destroy pagination links to show action 
    categories
  end
  
  private
    

  
  def find_website
    
    @website = if params[:business_website_id].present?
      Business::Website.find_by_id(params[:business_website_id])
    elsif has_model_params? && params[:blog_taxonomies_category].delete(:hide_website_col)
      Business::Website.find_by_id(model_params[:business_website_id])
    elsif params.delete(:hide_website_col)
      find_category
      @category.website
    elsif  action_name.eql?("edit")
      @show_website_col = true
      find_category
      @category.website
    end
  end
  
  def find_category
    @category = if params[:id].present?
      set_entry
    else
      Blog::Taxonomies::Category.new(website: @website)
    end
  end
  
  def categories
    if @website
      @categories = @website.categories.order(:name)
    else
      entries
      @categories = @categories.includes(:website)
    end 
    @categories_unpaginated = @categories 
    @categories = @categories.page(params[:page])
  end
  
  
end