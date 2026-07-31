Rails.application.routes.draw do
  root "home#index"

  scope "(:locale)", locale: /en|ru/ do
    ActiveAdmin.routes(self)
    get "/", to: "home#index"
    devise_for :users
    get "profile", to: "users#show"
    resources :learning_paths do
      resources :course_contents, shallow: true do
        resources :elements, module: :course_contents, only: [ :new, :create, :edit, :update, :destroy ]
      end
    end
  end
end
