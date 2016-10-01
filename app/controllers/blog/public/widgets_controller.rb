class Blog::Public::WidgetsController < Blog::Public::ApplicationController
  
  def archives
    @year = params[:year]
    @month = params[:month]
    if @month
      starts_at = Time.new(@year, @month, 1)
      ends_at = starts_at.end_of_month
      @posts = @website.posts.published.where('published_at >= ? and published_at <= ?', starts_at, ends_at)
      render template: 'blog/public/widgets/archives/posts'
    else
      @archives = @website.posts.published.where('extract(year from published_at) = ?', @year).group('extract(month from published_at)').count.map{|a,b| {month: a.to_i, count: b}}
      render template: 'blog/public/widgets/archives/months'
    end
  end
  
end