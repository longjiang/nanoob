require 'resque/server'

class DomainConstraint
  def self.matches? request
    matching_website?(request)
  end
  def self.matching_website? request
    url = "#{request.protocol}#{request.host.gsub('.local','').gsub('www.','')}"
    Business::Website.find_by_url(url).present?
  end
end

Rails.application.routes.draw do
  
  devise_for :users
  
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
    resources :users
    resources :blog_posts, controller: 'blog/posts', :concerns => :paginatable
  end
  
  match '/:year/:month/:slug', to: 'blog/public/posts#show', :constraints => DomainConstraint, via: [:get, :post], as: :post
  get '/page/:page', :constraints => DomainConstraint, to: 'blog/public/posts#index'
  root 'blog/public/posts#index', :constraints => DomainConstraint, via: [:get, :post]
  
  
  scope '/ws' do
    get '/forms/blog_post_slug_generator', to: 'webservice/forms#blog_post_slug_generator' 
    get '/forms/permalink_prefix', to: 'webservice/forms#permalink_prefix'
  end
  
  root 'welcome#index'
  
end
