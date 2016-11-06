class Blog::Public::AuthorsController < Blog::Public::ContentsController
  
  include Blog::Public::ThemeConcern
  
  def show
    @author = People::Author.find(params[:id].to_i).try(:decorate)
    @author.track self
    @category = @website.categories.find_by_slug('bien-choisir')
    if @category
      @posts = @category.posts.published.page(params[:page])
    end
  end
  
  def page_title
    @author.decorate.name
  end

end