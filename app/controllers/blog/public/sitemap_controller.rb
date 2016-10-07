class Blog::Public::SitemapController < Blog::Public::ApplicationController
  
  layout nil
  
  def index
    
    sitemaps = {
      'posts' => Time.now,
      'categories' => Time.now,
      'tags' => Time.now,
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
  
  def categories
    respond_to do |format|
      format.xml {@categories = @website.categories}
    end
  end
  
  def tags
    respond_to do |format|
      format.xml {@tags = @website.tags}
    end
  end
  
  def feed
    respond_to do |format|
      format.xsl 
    end
  end
  
end
