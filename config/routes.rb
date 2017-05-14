Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "requests#index"

  resources :requests, :only => [:index, :show, :create, :destroy, :edit]
  resources :requests do
    member do
      patch 'refresh'
    end
  end

end