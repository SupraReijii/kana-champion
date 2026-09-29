Rails.application.routes.draw do
  root "dashboard#index"
  resources :game, only: [:index]
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    get :kana, controller: :api_kana, action: :index
  end
end
