class Blog::Public::SearchController < Blog::Public::ContentsController
  
  def index
    @keywords = params[:keywords]
    @couleur = params[:couleur]
    @material = params[:material]
    @location = params[:location]
    @posts_unpaginated = @website.posts.published.where('lower(title) like ?', "%#{@keywords.downcase.gsub('-', ' ')}%")
    @posts = @posts_unpaginated.page(params[:page])
    render template: "themes/simple/search"
  end
  
end
