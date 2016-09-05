class Blog::Router
  
  class Route
    attr_accessor :method, :path, :constraints, :to, :via, :default, :as
    def initialize(method, path, to=nil, default=nil, via=nil)
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
      url = "#{request.protocol}#{request.host.gsub('.dev','').gsub('www.','')}"
      Business::Website.find_by_url(url).present?
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
  end

  def sitemaps
    self.routes << Route.new(:get, '/sitemap.xml',                    'blog/public/sitemap#index',       {:format => 'xml'})
    self.routes << Route.new(:get, '/sitemap/posts.xml',              'blog/public/sitemap#posts',       {:format => 'xml'})
    self.routes << Route.new(:get, '/sitemap/categories.xml',         'blog/public/sitemap#categories',  {:format => 'xml'})
    self.routes << Route.new(:get, '/sitemap/search/:dimensions.xml', 'blog/public/sitemap#search',      {:format => 'xml'})
    self.routes << Route.new(:get, '/sitemap-index.xsl',              'blog/public/sitemap#index',       {:format => 'xsl'})
    self.routes << Route.new(:get, '/sitemap.xsl',                    'blog/public/sitemap#feed',        {:format => 'xsl'})
  end
  
  def miscellaneous
    self.routes << Route.new(:get,    '/s-:keywords,:location,:dimensions',  'blog/public/posts#search')
    self.routes << Route.new(:get,    '/page/:page',                         'blog/public/posts#index')
    
    self.routes << Route.new(:get,    '/s-:keywords-couleur-:couleur-en-:material,:location',  'blog/public/posts#search')
    self.routes << Route.new(:get,    '/s-:keywords-couleur-:couleur,:location',  'blog/public/posts#search')
    self.routes << Route.new(:get,    '/s-:keywords-en-:material,:location',  'blog/public/posts#search')
    self.routes << Route.new(:get,    '/s-:keywords-couleur-:couleur',  'blog/public/posts#search')
    self.routes << Route.new(:get,    '/s-:keywords,:location',  'blog/public/posts#search')
    self.routes << Route.new(:get,    '/s-:keywords-en-:material',  'blog/public/posts#search')

    r = Route.new(:root,   'blog/public/posts#index')
    r.via = [:get, :post]
    self.routes << r
    
    r = Route.new(:match,  '/:year/:month/:slug', 'blog/public/posts#show')
    r.via = [:get, :post]
    r.as = :post
    self.routes << r
    
  end
  
  def self.load
    Rails.application.routes.draw do
      Blog::Router.new.routes.each do |r|
        send r.method, r.path, r.options
      end
      
      scope '/widgets' do
        get '/posts/:website_id(/:year)(/:month)', to: 'blog/public/posts#archives', as: :archives
      end
      
    end
  end
  
  def self.reload
    Rails.application.routes_reloader.reload!
  end
  

  
end
