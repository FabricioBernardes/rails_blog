Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_for :users

  root "home#index"

  namespace :admin do
    resources :posts, param: :slug
  end

  resources :posts, only: [ :index, :show ], param: :slug
  get "posts/*other", to: redirect("/")
end
