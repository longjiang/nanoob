require 'resque/server'

class DomainConstraint
  def self.matches? request
    matching_website?(request)
  end
  def self.matching_website? request
    url = "#{request.protocol}#{request.host.gsub('.dev','').gsub('www.','')}"
    Business::Website.find_by_url(url).present?
  end
end

Rails.application.routes.draw do
  
  devise_for :users, class_name: "People::User"
  
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  
  mount Resque::Server.new, :at => "/resque"
  
  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end
  
  scope "/do" do 
    resources :businesses
    resources :business_websites, controller: 'business/websites'
    resources :partners, :concerns => :paginatable
    resources :partner_requests, controller: 'partner/requests', :concerns => :paginatable
    resources :partner_backlinks, controller: 'partner/backlinks', :concerns => :paginatable
    resources :blog_posts, controller: 'blog/posts', :concerns => :paginatable
    resources :blog_categories, controller: 'blog/categories', :concerns => :paginatable
    resources :users, controller: 'people/users'
  end
  
  match '/:year/:month/:slug', to: 'blog/public/posts#show', :constraints => DomainConstraint, via: [:get, :post], as: :post
  get '/page/:page', :constraints => DomainConstraint, to: 'blog/public/posts#index'
  root 'blog/public/posts#index', :constraints => DomainConstraint, via: [:get, :post]
  
  
  scope '/ws' do
    get '/forms/blog_post_slug_generator',      to: 'webservice/forms#blog_post_slug_generator' 
    get '/forms/blog_post_permalink_prefix',    to: 'webservice/forms#blog_post_permalink_prefix'
    get '/forms/blog_category_slug_generator',  to: 'webservice/forms#blog_category_slug_generator' 
    get '/forms/blog_category_permalink_prefix',to: 'webservice/forms#blog_category_permalink_prefix'
    get '/forms/blog_post_published_at',        to: 'webservice/forms#blog_post_published_at'
  end
  
  root 'welcome#index'
  
end
