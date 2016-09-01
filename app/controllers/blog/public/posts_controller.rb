class Blog::Public::PostsController < Blog::Public::ApplicationController
  
  before_action      :javascript_file
  before_action      :stylesheet_file
  
  layout :layout
  
  def index
    @posts_unpaginated = @website.posts.published
    @posts = @posts_unpaginated.page(params[:page])
    @archives = @website.posts.published.group('extract(year from published_at)').count.map{|a,b| {year: a.to_i, count: b}}
    render template: "themes/simple/index"
  end
  
  def show
    @post = Blog::Post.website(@website).find_by_slug!(params[:slug])
    render template: "themes/simple/show"
  end
  
  def search
    @keywords = params[:keywords]
    @couleur = params[:couleur]
    @material = params[:material]
    @location = params[:location]
    @posts_unpaginated = @website.posts.published.where('lower(title) like ?', "%#{@keywords.downcase.gsub('-', ' ')}%")
    @posts = @posts_unpaginated.page(params[:page])
    render template: "themes/simple/search"
  end
  
  def archives
    sleep 3
    @year = params[:year]
    @month = params[:month]
    if @month
      starts_at = Time.new(@year, @month, 1)
      ends_at = starts_at.end_of_month
      @posts = @website.posts.published.where('published_at >= ? and published_at <= ?', starts_at, ends_at)
      render template: 'themes/widgets/archives/posts'
    else
      @archives = @website.posts.published.where('extract(year from published_at) = ?', @year).group('extract(month from published_at)').count.map{|a,b| {month: a.to_i, count: b}}
      render template: 'themes/widgets/archives/months'
    end
  end
  
  private
  
  def layout
    file = Rails.root.join('app', 'views', 'themes', @website.theme, 'layout.html.haml')
    theme = File.exist?(file) ? @website.theme : 'simple'
    "../themes/#{theme}/layout"
  end
  
  def javascript_file
    file = Rails.root.join('app', 'assets', 'themes', @website.theme, "javascripts", "index.js")
    theme = File.exist?(file) ? @website.theme : 'simple'
    @javascript_file = "#{theme}/javascripts/index"
  end
  
  def stylesheet_file
    file = Rails.root.join('app', 'assets', 'themes', @website.theme, "stylesheets", "index.scss")
    theme = File.exist?(file) ? @website.theme : 'simple'
    @stylesheet_file = "#{theme}/stylesheets/index"
  end
  
end
