Rails.application.routes.draw do
  
  devise_for :users
  
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  
  root 'welcome#index'
  
  scope "/do" do 
    resources :businesses
    resources :business_websites, controller: 'business/websites'
    resources :partners
    resources :partner_requests, controller: 'partner/requests'
    resources :partner_backlinks, controller: 'partner/backlinks'
    resources :users
  end
end
