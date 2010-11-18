Swccgvkit::Application.routes.draw do
  devise_for :users

  get "home/index", :as => :home
  get "home/about", :as => :about
  get "home/settings", :as => :settings
  
  resources :cards
  root :to => "home#index"

  match ':controller(/:action(/:id(.:format)))'
end
