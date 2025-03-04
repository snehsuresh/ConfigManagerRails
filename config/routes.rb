# config/routes.rb
Rails.application.routes.draw do
  # Web (admin) interface for app configurations
  resources :app_configurations

  # API endpoints versioned under /api/v1
  namespace :api do
    namespace :v1 do
      resources :app_configurations, only: [:index, :show, :create, :update] do
        collection do
          get :simulate_shipping, defaults: { format: :json }
        end
      end
    end
  end


  root to: 'app_configurations#index'
end
