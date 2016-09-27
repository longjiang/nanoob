class Blog::Public::PostsController < Blog::Public::ContentsController
  
  def index
    @posts_unpaginated = @website.posts.published
    @posts = @posts_unpaginated.page(params[:page])
    @archives = @website.posts.published.group('extract(year from published_at)').count.map{|a,b| {year: a.to_i, count: b}}
    render template: "themes/simple/index"
  end
  
  def show
    @post = Blog::Contents::Post.website(@website).find_by_slug!(params[:slug])
    render template: "themes/simple/post"
  end
  
end
