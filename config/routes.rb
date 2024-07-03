# frozen_string_literal: true

Rails.application.routes.draw do
  root "static_pages#home"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: %i[index show]
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :posts, only: %i(create update destroy) do
    resources :reactions, only: %i(create destroy), shallow: true
    patch "update_status", to: "posts#update_status", on: :member
  end
  resources :relationships, only: %i(create destroy)
  namespace :api do
    post "/signup", to: "users#create"
    post "/login", to: "sessions#create"
    resources :users, only: %i[index show]
  end
end
