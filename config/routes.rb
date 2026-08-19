require "sidekiq/web"

Rails.application.routes.draw do
  root "home#index"

  scope "(:locale)", locale: /en|ru/ do
    ActiveAdmin.routes(self)
    get "/", to: "home#index"
    devise_for :users
    get "profile", to: "users#show"
    get "analytics", to: "analytics#index"
    resources :learning_paths do
      resources :course_contents, shallow: true do
        resources :elements, module: :course_contents, only: [ :new, :create, :edit, :update, :destroy ]
        resources :quizzes, shallow: false do
          post :submit, on: :member
        end
      end
      resources :enrollments, only: [ :create ]
    end
    authenticate :user, ->(user) { user.admin? } do
      mount Sidekiq::Web => "/admin/sidekiq"
    end
  end
end
