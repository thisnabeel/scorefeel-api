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
  end

  resources :pictures, only: [:index, :show, :create, :update, :destroy] do
    post :upload_picture, on: :member
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
