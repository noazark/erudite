Erudite::Application.routes.draw do
  resources :documents

  get :dashboard, controller: "Dashboard", action: :index
  get :search, controller: "Search", action: :show

  #get \"users\/show\"

  root :to => "search#show"

  devise_for :users
  resources :users, :only => :show

  mount Resque::Server, :at => "/resque", :as => :resque
end
