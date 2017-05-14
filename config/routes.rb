Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "requests#index"

  resources :requests, :only => [:index, :show, :create, :destroy]
  resources :requests do
    member do
      patch 'refresh'
    end
  end

  resources :tests, :only => [:create, :destroy]

end