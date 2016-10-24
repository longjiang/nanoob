class Blog::Public::PostsController < Blog::Public::ContentsController
  
  include Blog::Public::ThemeConcern
  
  def index
    @posts_unpaginated = @website.posts.publicized.order(published_at: 'desc')
    @posts = @posts_unpaginated.page(params[:page])
  end
  
  def show
    @post = Blog::Contents::Post.website(@website).find_by_slug!(params[:slug])
    @post.track(self)
     woopra_track 'nanoob article', {
      title: @post.title, 
      permalink: post_url(slug: @post.slug, year: @post.year, month: @post.month), 
      "post date" => (@post.published? ? @post.published_at : @post.updated_at), 
      status: @post.status,
      author: @post.author.decorate.name 
    }
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
