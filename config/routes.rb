require 'resque/server'

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
    resources :blog_pages, controller: 'blog/pages', :concerns => :paginatable
    resources :blog_categories, controller: 'blog/categories', :concerns => :paginatable
    resources :users, controller: 'people/users'
  end

  Blog::Router.load
  
  scope '/ws' do
    get '/forms/blog_page_slug_generator',      to: 'webservice/forms#blog_page_slug_generator' 
    get '/forms/blog_page_permalink_prefix',    to: 'webservice/forms#blog_page_permalink_prefix'
    get '/forms/blog_post_slug_generator',      to: 'webservice/forms#blog_post_slug_generator' 
    get '/forms/blog_post_permalink_prefix',    to: 'webservice/forms#blog_post_permalink_prefix'
    get '/forms/blog_category_slug_generator',  to: 'webservice/forms#blog_category_slug_generator' 
    get '/forms/blog_category_permalink_prefix',to: 'webservice/forms#blog_category_permalink_prefix'
    get '/forms/blog_post_published_at',        to: 'webservice/forms#blog_post_published_at'
    get '/forms/blog_page_published_at',        to: 'webservice/forms#blog_page_published_at'
  end
  
  root 'welcome#index'
  
end
