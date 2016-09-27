class Blog::Public::ContentsController < Blog::Public::ApplicationController

  before_action      :javascript_file
  before_action      :stylesheet_file

  layout :layout

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