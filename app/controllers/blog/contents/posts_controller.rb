class Blog::Contents::PostsController < Blog::ContentsController
  
  def index
    super
    @posts = @posts.includes(:owner).includes(:metum)
    @posts = @posts.includes(:categories) unless params[:category_id]
    @posts = @posts.includes(:tags) unless params[:tag_id]
    @posts = @posts.includes(:website) unless @website
    @posts_unpaginated = @posts
    @posts = @posts.page(params[:page])
    @posts_not_status_filtered = Blog::Contents::Post.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params - [:status, :published_after, :published_before]))
    @posts_not_owner_filtered = Blog::Contents::Post.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params - [:owner]))
  end
  
  private
  
  def update_bodies
    p = params[:blog_contents_post]
    p[:body]    = p[:body_xs] unless p[:body_xs].eql?(p.delete(:body_xs_was))
    p[:body_xs] = p[:body]    unless p[:body].eql?(p.delete(:body_was)) 
  end
  
  def nilify_published_at
    (1..5).each {|i| params[:blog_contents_post].delete("published_at(#{i}i)")} if params[:blog_contents_post].delete(:publish_now)
  end
  
  def add_menu_items
    @menu.update do |menu|
      menu.update I18n.t("menu.blog/contents/posts"), blog_contents_posts_path(owner: current_user.id, business_id: current_user.business_id, business_website_id: current_user.website_id), 'posts', {icon: Blog::Contents::Post.decorator_class.icon} do |submenu|
        submenu.add I18n.t("menu.blog/contents/post.all"), blog_contents_posts_path, {icon: false}
        submenu.add I18n.t("menu.blog/contents/post.add_new"), new_blog_contents_post_path(business_website_id: current_user.website_id), {icon: false}
        submenu.add I18n.t("menu.blog/taxonomies/categories.all"), blog_taxonomies_categories_path(business_website_id: @website ? @website.id : current_user.website_id), {icon: false}
        submenu.add I18n.t("menu.blog/taxonomies/tags.all"), blog_taxonomies_tags_path(business_website_id: @website ? @website.id : current_user.website_id), {icon: false}
      end
    end
  end
  
  def new_object_path
    new_blog_contents_post_path(business_website_id: @website.try(:id))
  end
  
end