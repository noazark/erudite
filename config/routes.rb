Erudite::Application.routes.draw do
  resources :documents

  get :dashboard, controller: "Dashboard", action: :index

  #get \"users\/show\"

  root :to => "home#index"

  devise_for :users
  resources :users, :only => :show
  
  mount Resque::Server, :at => "/resque", :as => :resque
end
