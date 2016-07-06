Rails.application.routes.draw do
  
  devise_for :users
  
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  
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
end
