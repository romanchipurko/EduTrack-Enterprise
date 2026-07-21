Rails.application.routes.draw do
  root "home#index"

  scope "/:locale", locale: /en|ru/ do
    get "/", to: "home#index"
    devise_for :users
    get "profile", to: "users#show"
    resources :learning_paths, only: [ :index, :show ]
  end
end
