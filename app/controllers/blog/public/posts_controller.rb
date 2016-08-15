class Blog::Public::PostsController < ApplicationController
  
  skip_before_filter :authenticate_user!
  skip_before_filter :init_menu
  skip_before_filter :menu_activate
  before_filter      :find_website
  before_filter      :javascript_file
  before_filter      :stylesheet_file
  
  layout :layout
  
  def index
    @posts = @website.posts.published
    render template: "themes/simple/index"
  end
  
  def show
    @post = Blog::Post.website(@website).find_by_slug!(params[:slug])
    render template: "themes/simple/show"
  end
  
  private
  
  def find_website
    @website ||= Business::Website.find_by_url("#{request.protocol}#{request.host.gsub('.local','').gsub('www.','')}")
  end
  
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
