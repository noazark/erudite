Erudite::Application.routes.draw do
  resources :documents, only: [:index, :show, :new, :create, :destroy]

  root :to => "documents#index"

  mount Resque::Server, :at => "/resque", :as => :resque
end
