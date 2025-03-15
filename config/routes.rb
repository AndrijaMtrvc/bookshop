Rails.application.routes.draw do
  # Spremenjen root na home#index
  root "home#index"

  resource :session, only: [:new, :create]
  delete "logout", to: "sessions#destroy", as: :logout

  get "login", to: "sessions#new"
  resources :users, only: [:new, :create]

  get "/admin", to: "admin#index", as: :admin
  namespace :admin do
    resources :books, only: [:edit, :update]
  end

  resources :shop, controller: "shop", only: [:index, :show] do
    member do
      post "add_to_cart"
    end
    collection do
      get "cart"
      patch "update_cart"
      delete "remove_from_cart"
      delete "clear_cart"
    end
  end

  # Dodana pot za HomeController
  get "home/index"
end