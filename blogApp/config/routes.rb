Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  #login/sign up endpoints
  post "user/create", to: "user#signUp"
  get "user/login", to: "user#signIn"

  #posts endpoints
  post "post/new", to: "post#create"
  put "post/update", to: "post#updatePost"
  put "post/tags", to: "tag#updateTags"
  delete "post", to: "post#deletePost"

  #comments endpoints
  post "comment/create", to: "comment#addComment"
  delete "comment", to: "comment#deleteComment"
  put "comment", to: "comment#editComment"

  # Defines the root path route ("/")
  # root "posts#index"
end
