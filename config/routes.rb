Rails.application.routes.draw do
  devise_for :administrators, controllers: { sessions: 'administrators/sessions' }
  get 'up' => 'rails/health#show', as: :rails_health_check

  root to: 'home#index'

  namespace :administrators do
    root to: 'home#index'
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
