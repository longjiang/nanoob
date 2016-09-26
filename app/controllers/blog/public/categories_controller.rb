class Blog::Public::CategoriesController < Blog::Public::PostsController
  
  def index
    @category = @website.categories.find_by_slug!(params[:slug])
    @posts = @category.posts.published.page(params[:page])
    render template: "themes/simple/category"
  end
  
end