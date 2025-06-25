Rails.application.routes.draw do
  # API Routes

  resources :figures, only: [:index, :show, :create, :update, :destroy]
  resources :sports, only: [:index, :show, :create, :update, :destroy]
  resources :sport_rules, only: [:index, :show, :create, :update, :destroy]
  resources :relationships, only: [:index, :show, :create, :update, :destroy]
  resources :events, only: [:index, :show, :create, :update, :destroy]
  resources :tags, only: [:index, :show, :create, :update, :destroy]
  resources :stories, only: [:index, :show, :create, :update, :destroy]
  resources :pictures, only: [:index, :show, :create, :update, :destroy]
  resources :blurbs, only: [:index, :show, :create, :update, :destroy]
  resources :bullet_points, only: [:index, :show, :create, :update, :destroy]
  resources :pages, only: [:index, :show, :create, :update, :destroy]
  
  # Custom route for getting blurbs by blurbable
  get 'blurbs/for/:blurbable_type/:blurbable_id', to: 'blurbs#for_blurbable'
  post 'blurbs/for/:blurbable_type/:blurbable_id/wizard', to: 'blurbs#wizard'
  
  # Custom routes for getting bullet points by bullet_pointable
  get 'bullet_points/for/:bullet_pointable_type/:bullet_pointable_id', to: 'bullet_points#for_bullet_pointable'
  post 'bullet_points/for/:bullet_pointable_type/:bullet_pointable_id/wizard', to: 'bullet_points#wizard'
  
  # Custom routes for getting pages by pageable
  get 'pages/for/:pageable_type/:pageable_id', to: 'pages#for_pageable'
  get 'pages/by-slug/:slug', to: 'pages#by_slug'
  
  # Additional nested routes for better API design
  resources :sports, only: [:index, :show, :create, :update, :destroy] do
    resources :figures, only: [:index]
    resources :sport_rules, only: [:index, :create]
    resources :events, only: [:index]
    resources :stories, only: [:index]
    post :generate_figures, on: :member
    post :generate_story, on: :member
    post :generate_sport_rules, on: :member
    post :generate_events, on: :member
  end
  
  resources :figures, only: [:index, :show, :create, :update, :destroy] do
    resources :relationships, only: [:index]
    resources :events, only: [:index, :create]
    resources :stories, only: [:index, :create]
    resources :pictures, only: [:index, :create]
    post :generate_story, on: :member
    post :upload_picture, on: :member
  end

  resources :events, only: [:index, :show, :create, :update, :destroy] do
    resources :stories, only: [:index, :create]
    post :generate_story, on: :member
  end

  resources :stories, only: [:index, :show, :create, :update, :destroy] do
    resources :pictures, only: [:index, :create]
    post :generate_pictures, on: :member
    post :upload_picture, on: :member
    get :validate, on: :member
  end

  resources :pictures, only: [:index, :show, :create, :update, :destroy] do
    post :upload_picture, on: :member
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
