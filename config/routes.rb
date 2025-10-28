Rails.application.routes.draw do
  devise_for :administrators, controllers: { sessions: 'administrators/sessions' }

  root 'accommodations#index'

  resources :accommodations, only: %i[index show]

  namespace :administrators do
    root 'accommodations#index'
    resources :accommodations, only: %i[index show new edit create update destroy]
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  get 'up' => 'rails/health#show', as: :rails_health_check
end
