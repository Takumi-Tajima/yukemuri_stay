Rails.application.routes.draw do
  devise_for :users
  devise_for :administrators, controllers: { sessions: 'administrators/sessions' }

  root 'accommodations#index'

  resources :accommodations, only: %i[index show] do
    resources :room_types, only: %i[show], module: :accommodations do
      resources :reservations, only: %i[new create], module: :room_types do
        collection do
          post 'confirm'
        end
      end
    end
  end

  namespace :my do
    resources :upcoming_reservations, only: %i[index show] do
      resource :cancellation_status, only: %i[update], module: :upcoming_reservations
    end
    resources :past_reservations, only: %i[index show] do
      resource :review, only: %i[new create], module: :past_reservations
    end
  end

  namespace :administrators do
    root 'accommodations#index'
    resources :accommodations, only: %i[index show new edit create update destroy] do
      resources :room_types, only: %i[show new edit create update destroy], module: :accommodations do
        resources :room_availabilities, only: %i[new edit create update], module: :room_types
      end
    end
    resources :reservations, only: %i[index show edit update]
    resources :users, only: %i[index show destroy]
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  get 'up' => 'rails/health#show', as: :rails_health_check
end
