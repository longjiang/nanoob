class Blog::Public::PostsController < Blog::Public::ContentsController
  
  def index
    @posts_unpaginated = @website.posts.publicized.order(published_at: 'desc')
    @posts = @posts_unpaginated.page(params[:page])
    @archives = @website.posts.published.order('extract(year from published_at) desc').group('extract(year from published_at)').count.map{|a,b| {year: a.to_i, count: b}}
    render template: "themes/simple/index"
  end
  
  def show
    @post = Blog::Contents::Post.website(@website).find_by_slug!(params[:slug])
    @post.track(self)
    @archives = @website.posts.publicized.group('extract(year from published_at)').count.map{|a,b| {year: a.to_i, count: b}}
    woopra_track 'nanoob article', {
      title: @post.title, 
      permalink: post_url(slug: @post.slug, year: @post.year, month: @post.month), 
      "post date" => (@post.published? ? @post.published_at : @post.updated_at), 
      status: @post.status,
      author: @post.author.decorate.name 
    }
    render template: "themes/simple/post"
  end
    
  def page_title
    case action_name
    when 'index'
      @website.decorate.title
    when 'show'
      @post.decorate.title
    end
  end
  
  def page_title_template
    case action_name
    when 'index'
      "%%sitename%%"
    else
      super
    end
  end
  
end
