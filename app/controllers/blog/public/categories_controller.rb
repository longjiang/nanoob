class Blog::Public::CategoriesController < Blog::Public::ContentsController
  
  def index
    @category = @website.categories.find_by_slug(params[:slug])
    if @category
      @posts = @category.posts.published.page(params[:page])
      render template: "themes/simple/category"
    else
      @website.add_unknown_category(params[:slug])
      @website.save
      redirect_to root_path(keywords: params[:slug])
    end
  end
  
  def page_title
    @category.decorate.name
  end
  
end