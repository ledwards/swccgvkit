Swccgvkit::Application.routes.draw do
  devise_for :users

  get "home/index", :as => :home
  get "home/about", :as => :about
  get "home/settings", :as => :settings
  post "add_card", :to => "cardlists#add_card", :as => "add_card"
  
  resources :cards
  resources :users
  resources :cardlists
  
  root :to => "home#index"
end
