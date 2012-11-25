Erudite::Application.routes.draw do
  resources :documents

  get :search, controller: "Search", action: :show

  root :to => "documents#index"

  devise_for :users

  mount Resque::Server, :at => "/resque", :as => :resque
end
