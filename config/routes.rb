Rails.application.routes.draw do


  resources :users, only: [:index, :show, :create, :update, :destroy] do
    collection do
      post 'sign_in'
      post 'sign_up'
      get 'current_user_info'
    end
    member do
      post 'add_role'
      post 'remove_role'
    end
  end

  # API Routes

  resources :sports, only: [:index, :show, :create, :update, :destroy] do
    member do
      get 'wizard', action: :wizard
      post 'generate/story', action: :generate_story
    end
    resources :stories, only: [:index, :show, :create, :update, :destroy]
    resources :events, only: [:index, :show, :create, :update, :destroy]
    resources :pages, only: [:index, :show, :create, :update, :destroy]
    resources :sport_rules, only: [:index, :show, :create, :update, :destroy]
    resources :figures, only: [:index, :show, :create, :update, :destroy]
  end

  resources :figures, only: [:index, :show, :create, :update, :destroy] do
    member do
      get 'wizard', action: :wizard
    end
  end

  resources :sport_rules, only: [:index, :show, :create, :update, :destroy] do
    member do
      get 'wizard', action: :wizard
    end
  end

  resources :relationships, only: [:index, :show, :create, :update, :destroy] do
    member do
      get 'wizard', action: :wizard
    end
  end

  resources :events, only: [:index, :show, :create, :update, :destroy] do
    member do
      get 'wizard', action: :wizard
    end
  end

  resources :tags, only: [:index, :show, :create, :update, :destroy]

  resources :stories, only: [:index, :show, :create, :update, :destroy] do
    member do
      get 'wizard', action: :wizard
      post 'generate_pictures', action: :generate_pictures
    end
    resources :pictures, only: [:index, :show, :create, :update, :destroy]
  end

  resources :pictures, only: [:index, :show, :create, :update, :destroy] do
    member do
      get 'wizard', action: :wizard
      post 'upload_picture', action: :upload_picture
    end
  end

  resources :blurbs, only: [:index, :show, :create, :update, :destroy] do
    collection do
      get 'for/:blurbable_type/:blurbable_id', action: :for_blurbable
      get 'for/:blurbable_type/:blurbable_id/wizard', action: :wizard
    end
  end

  resources :bullet_points, only: [:index, :show, :create, :update, :destroy] do
    collection do
      get 'for/:bullet_pointable_type/:bullet_pointable_id/wizard', action: :wizard
      post 'for/:bullet_pointable_type/:bullet_pointable_id/wizard', action: :wizard
    end
  end

  resources :pages, only: [:index, :show, :create, :update, :destroy]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root 'application#index'
end 