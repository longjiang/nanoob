class Blog::Public::SitemapController < Blog::Public::ApplicationController
  
  layout nil
  
  def index
    
    sitemaps = {
      'posts' => Time.now,
      'categories' => Time.now,
      'search/miscellaneous' => Time.now,
      'search/products' => Time.now
    }
    
    respond_to do |format|
      format.xml { @sitemaps = sitemaps }
      format.xsl
    end
  end
  
  def posts
    respond_to do |format|
      format.xml {@posts = @website.posts}
    end
  end
  
  def feed
    respond_to do |format|
      format.xsl 
    end
  end
  
end
