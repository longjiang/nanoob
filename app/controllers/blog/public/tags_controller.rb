class Blog::Public::TagsController < Blog::Public::PostsController
  
  def index
    @tag = @website.tags.find_by_slug(params[:slug])
    if @tag
      @posts = @tag.posts.published.page(params[:page])
      render template: "themes/simple/tag"
    else
      @website.add_unknown_tag(params[:slug])
      @website.save
      redirect_to root_path(keywords: params[:slug])
    end
  end
  
end