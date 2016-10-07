class Blog::Router
  
  class Route
    attr_accessor :method, :path, :constraints, :to, :via, :default, :as
    def initialize(method, path, to=nil, default=nil, via=nil)
      to = "blog/public/#{to}" unless to.blank?
      @method   = method
      @path     = path
      @to       = to
      @via      = via
      @default  = default
    end
    def options
      {to: to, via: via, default: default, as: as, constraints: constraints || DefaultConstraint.new}
    end
  end
  
  class DefaultConstraint
    def matches? request
      website_exists? request
    end
    
    def website_exists? request
      Business::Website.find_by_request(request).present?
    end
  end
  
  class PostShowConstraint < DefaultConstraint
    def matches? request
      website_exists? request
    end
    
  end
  
  class TestConstraint
    def matches? request   
      url = "#{request.protocol}#{request.host.gsub('.dev','').gsub('www.','')}"
      request.params[:keywords] !~ /,/ && Business::Website.find_by_url(url).present?
    end
  end 
  
  attr_accessor :routes
  
  def initialize
    @routes = []
    sitemaps
    miscellaneous
    tags
    categories
    authors
    posts
    pages
  end

  def sitemaps
    self.routes << Route.new(:get, '/sitemap.xml',                    'sitemap#index',       {:format => 'xml'})
    self.routes << Route.new(:get, '/sitemap/posts.xml',              'sitemap#posts',       {:format => 'xml'})
    self.routes << Route.new(:get, '/sitemap/categories.xml',         'sitemap#categories',  {:format => 'xml'})
    self.routes << Route.new(:get, '/sitemap/tags.xml',               'sitemap#tags',        {:format => 'xml'})
    self.routes << Route.new(:get, '/sitemap/search/:dimensions.xml', 'sitemap#search',      {:format => 'xml'})
    self.routes << Route.new(:get, '/sitemap-index.xsl',              'sitemap#index',       {:format => 'xsl'})
    self.routes << Route.new(:get, '/sitemap.xsl',                    'sitemap#feed',        {:format => 'xsl'})
  end
  
  def miscellaneous
    self.routes << Route.new(:get,    '/s-:keywords,:location,:dimensions',  'search#index')
    
    self.routes << Route.new(:get,    '/s-:keywords-couleur-:couleur-en-:material,:location',  'search#index')
    self.routes << Route.new(:get,    '/s-:keywords-couleur-:couleur,:location',  'search#index')
    self.routes << Route.new(:get,    '/s-:keywords-en-:material,:location',  'search#index')
    self.routes << Route.new(:get,    '/s-:keywords-couleur-:couleur',  'search#index')
    self.routes << Route.new(:get,    '/s-:keywords,:location',  'search#index')
    self.routes << Route.new(:get,    '/s-:keywords-en-:material',  'search#index')
  end
  
  def tags
    r = Route.new(:get, '/tag/:slug(/page/:page)', 'tags#index')
    r.as = :tag
    self.routes << r
  end
  
  def categories
    r = Route.new(:get, '/category/:slug(/page/:page)', 'categories#index')
    r.as = :category
    self.routes << r
  end
  
  def authors
    r = Route.new(:get, '/author/:id/:slug(/page/:page)', 'authors#index')
    r.as = :author
    self.routes << r
  end
  
  def posts
    r = Route.new(:match, '/:year/:month/:slug', 'posts#show')
    r.via = [:get, :post]
    r.as = :post
    self.routes << r
    
    r = Route.new(:root, 'blog/public/posts#index')
    r.via = [:get, :post]
    self.routes << r
    
    self.routes << Route.new(:get, '/page/:page', 'posts#index')
  end
  
  def pages
    r = Route.new(:get,    '/:slug', 'pages#show')
    r.as = :page
    self.routes << r
  end

  
  def self.load
    Rails.application.routes.draw do
      Blog::Router.new.routes.each do |r|
        send r.method, r.path, r.options
      end
      
      scope '/widgets' do
        get '/posts/:website_id(/:year)(/:month)', to: 'blog/public/widgets#archives', as: :archives
      end
      
    end
  end
  
  def self.reload
    Rails.application.routes_reloader.reload!
  end
  

  
end

