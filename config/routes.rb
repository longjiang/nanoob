Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  scope "/do" do 
    resources :businesses
    resources :business_websites, controller: 'business/websites'
  end
end
