Rails.application.routes.draw do
  devise_for :users
  devise_for :administrators, controllers: { sessions: 'administrators/sessions' }

  root 'accommodations#index'

  resources :accommodations, only: %i[index show] do
    resources :room_types, only: %i[show], module: :accommodations
  end

  namespace :users do
    resources :home, only: %i[index]
  end

  namespace :administrators do
    root 'accommodations#index'
    resources :accommodations, only: %i[index show new edit create update destroy] do
      resources :room_types, only: %i[show new edit create update destroy], module: :accommodations do
        resources :room_availabilities, only: %i[new edit create update], module: :room_types
      end
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  get 'up' => 'rails/health#show', as: :rails_health_check
end
