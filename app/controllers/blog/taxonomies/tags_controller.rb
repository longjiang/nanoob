class Blog::Taxonomies::TagsController < Blog::TaxonomiesController
  
  before_action :find_tag, except: [:destroy, :show]
  
  def index
    tags
  end
  
  def update
    super do |format, updated|
      tags
      if updated 
        @category = Blog::Taxonomies::Tag.new(website: @website)
        format.js { render 'updated' }
      else
        @flash_danger = "Tag not updated"
        format.js { render 'edit' }
      end
    end
  end
  
  def create
    super do |format, created|
      tags
      if created 
         format.js { render 'created' }
      else
        @flash_danger = "Tag not created"
        format.js { render 'new' }
      end
    end
  end
  
  def destroy
    super do |format, destroyed|
      tags
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
    tags
  end

  
  private
    

  
  def find_website
    
    @website = if params[:business_website_id].present?
      Business::Website.find_by_id(params[:business_website_id])
    elsif has_model_params? && params[:blog_taxonomies_tag].delete(:hide_website_col)
      Business::Website.find_by_id(model_params[:business_website_id])
    elsif params.delete(:hide_website_col)
      find_tag
      @tag.website
    elsif  action_name.eql?("edit")
      @show_website_col = true
      find_tag
      @tag.website
    end
  end
  
  def find_tag
    @tag = if params[:id].present?
      set_entry
    else
      Blog::Taxonomies::Tag.new(website: @website)
    end
  end
  
  def tags
    if @website
      @tags = @website.tags.order(:name)
    else
      entries
      @tags = @tags.includes(:website)
    end 
    @tags_unpaginated = @tags 
    @tags = @tags.page(params[:page])
  end
  
  
end