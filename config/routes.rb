Swccgvkit::Application.routes.draw do
  devise_for :users

  get "home/index", :as => :home
  get "home/about", :as => :about
  get "home/settings", :as => :settings
  
  post "cardlists/add_card", :to => "cardlists#add_card", :as => "add_card"
  post "cardlists/update_quantity", :to => "cardlists#update_quantity", :as => "update_quantity"
  post "cardlists/update_title", :to => "cardlists#update_title", :as => "update_title"
  
  resources :cards
  resources :users
  resources :cardlists
  
  root :to => "home#index"
end
