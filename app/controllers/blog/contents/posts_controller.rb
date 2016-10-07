class Blog::Contents::PostsController < Blog::ContentsController
  
  before_action :init_statistics, only: [:show]
  
  def index
    super
    @posts = @posts.includes(:metum)
    @posts = @posts.includes(:owner) if params[:owner].blank?
    @posts = @posts.includes(:editor) if params[:editor].blank?
    @posts = @posts.includes(:writer) if params[:writer].blank?
    @posts = @posts.includes(:optimizer) if params[:optimizer].blank?
    @posts = @posts.includes(:categories) if params[:category_id].blank?
    @posts = @posts.includes(:tags) if params[:tag_id].blank?
    @posts = @posts.includes(:website) unless @website
    @posts_unpaginated = @posts
    @posts = @posts.page(params[:page])
    @posts_not_status_filtered = Blog::Contents::Post.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params - [:status, :published_after, :published_before]))
    @posts_not_user_filtered = Blog::Contents::Post.sort(params.slice(*sortable_params)).filter(params.slice(*filtering_params - [:owner, :writer, :editor, :optimizer]))
  end
  
  def show
      @deck = Dashboard::Deck.new(template: 'one') do |deck|
      
        deck.add cssclass: 'success', 
                 icon: @post.attribute_icon(:views_count), 
                 count: @post.views_count, 
                 label: han('blog/contents/post', :views_count, count: @post.views_count).humanize,
                 path: @post.views_count.eql?(0) ? '' : '#views' 
               
       deck.add cssclass: 'danger', 
                icon: @post.attribute_icon(:comments_count), 
                count: @post.comments_count, 
                label: han('blog/contents/post', :comments_count, count: @post.comments_count).humanize
      
        deck.add cssclass: 'warning', 
                 icon: @post.attribute_icon(:words_count), 
                 count: @post.words_count, 
                 label: han('blog/contents/post', :words_count, count: @post.words_count).humanize,
                 path: @post.words_count.eql?(0) ? '' : '#words' 
               
       deck.add cssclass: 'primary', 
                icon: @post.attribute_icon(:anchors_count), 
                count: @post.anchors_count, 
                label: han('blog/contents/post', :anchors_count, count: @post.anchors_count).humanize,
                path: @post.anchors_count.eql?(0) ? '' : '#anchors' 
    end
  end
  
  private
  
  def default_users
    entry.owner = current_user unless entry.owner 
    entry.writer = current_user unless entry.writer
    entry.editor = current_user unless entry.editor
    entry.optimizer = current_user unless entry.optimizer   
  end
  
  def update_bodies
    p = params[:blog_contents_post]
    %w(body body_xs body_was body_xs_was).each do |attr|
      p[attr.to_sym]    = p[attr.to_sym].gsub(/\s+/," ").gsub("\r\n"," ") unless p[attr.to_sym].blank?
    end
    p[:body]    = p[:body_xs] unless p[:body_xs].eql?(p.delete(:body_xs_was))
    p[:body_xs] = p[:body]    unless p[:body].eql?(p.delete(:body_was)) 
  end
  
  def nilify_published_at
    (1..5).each {|i| params[:blog_contents_post].delete("published_at(#{i}i)")} if params[:blog_contents_post].delete(:publish_now).to_s.eql?('true')
  end
  
  def add_menu_items
    link_params = current_user.last_filters['blog/contents/posts'].blank? ? {mine: current_user.id, business_id: current_user.business_id, business_website_id: current_user.website_id} : current_user.last_filters['blog/contents/posts']
    @menu.update do |menu|
      menu.update I18n.t("menu.blog/contents/posts"), blog_contents_posts_path(link_params), 'posts', {icon: Blog::Contents::Post.decorator_class.icon} do |submenu|
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
  
  def init_statistics
    @post.init_statistics
  end
  
end