require 'resque/server'

class DomainConstraint
  def self.matches? request
    matching_website?(request)
  end
  def self.matching_website? request
    url = "#{request.protocol}#{request.domain}"
    Business::Website.find_by_url(url).present?
  end
end

Rails.application.routes.draw do
  
  devise_for :users
  
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  
  mount Resque::Server.new, :at => "/resque"
  
  root 'welcome#index'
  
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
  end
  
  match '/:year/:month/:slug', to: 'posts#show', :constraints => DomainConstraint, via: [:get, :post]
end
