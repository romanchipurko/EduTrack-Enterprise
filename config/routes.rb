Rails.application.routes.draw do
  root "home#index"
  devise_for :users

  scope "/:locale", locale: /en|ru/ do
   get "/" => "home#index"
  end
end
