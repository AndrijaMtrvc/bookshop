# config/routes.rb
Rails.application.routes.draw do
  root "home#index"

  resource :session, only: [:new, :create]
  delete "logout", to: "sessions#destroy", as: :logout

  get "login", to: "sessions#new"
  resources :users, only: [:new, :create]

  get "/admin", to: "admin/books#index", as: :admin # Posodobljeno, da kaže na Admin::BooksController#index
  namespace :admin do
    resources :books, only: [:new, :create, :edit, :update, :destroy]
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
      get "checkout"
      post "complete_checkout"
    end
  end

  get "home/index"
end