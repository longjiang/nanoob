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
    resources :blog_contents_posts, controller: 'blog/contents/posts', :concerns => :paginatable
    resources :blog_contents_pages, controller: 'blog/contents/pages', :concerns => :paginatable
    resources :blog_taxonomies_categories, controller: 'blog/taxonomies/categories', :concerns => :paginatable
    resources :blog_taxonomies_tags, controller: 'blog/taxonomies/tags', :concerns => :paginatable
    resources :users, controller: 'people/users'
  end

  Blog::Router.load
  
  scope '/ws' do
    get '/forms/blog_slug_generator',           to: 'webservice/forms#blog_slug_generator' 
    get '/forms/blog_permalink_prefix',         to: 'webservice/forms#blog_permalink_prefix'
   
    get '/forms/blog_contents_post_published_at',        to: 'webservice/forms#blog_contents_post_published_at'
    get '/forms/blog_contents_page_published_at',        to: 'webservice/forms#blog_contents_page_published_at'
  end
  
  root 'welcome#index'
  
end
