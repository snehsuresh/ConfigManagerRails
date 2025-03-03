# config/routes.rb
Rails.application.routes.draw do
  # Web (admin) interface routes
  resources :app_configurations

  # API endpoints (versioned)
  namespace :api do
    namespace :v1 do
      resources :configurations, only: [:index, :show, :create, :update]
    end
  end

  # Root route
  root to: 'app_configurations#index'
end
