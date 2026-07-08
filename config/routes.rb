Rails.application.routes.draw do
  root "home#index"

  scope "/:locale", locale: /en|ru/ do
    get "/" => "home#index"
    devise_for :users
    get "profile", to: "users#show", as: :profile
  end
end
