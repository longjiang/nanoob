class Blog::Public::ContentsController < Blog::Public::ApplicationController

  abstract!
  
  include MetaConcern
  
  
  before_action      :archives

  private
  
  def archives
    @archives = @website.posts.published.order('extract(year from published_at) desc').group('extract(year from published_at)').count.map{|a,b| {year: a.to_i, count: b}}
  end
  


end