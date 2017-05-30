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
  resources :users, :only => [:index, :create, :destroy]

  resources :settings, :only => [:index] do
    collection do
      patch 'set_pager_duty_service_key'
    end
  end

end