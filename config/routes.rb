Rails.application.routes.draw do
  root "home#index"

  scope "/:locale", locale: /en|ru/ do
   get "/" => "home#index"
  end
end
