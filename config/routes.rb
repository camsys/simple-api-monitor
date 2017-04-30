Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "requests#index"

  resources :requests, :only => [:index, :show]

end