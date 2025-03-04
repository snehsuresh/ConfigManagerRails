# app/controllers/api/v1/app_configurations_controller.rb
module Api
  module V1
    class AppConfigurationsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def index
        app_configurations = AppConfiguration.all
        render json: app_configurations
      end

      def show
        app_configuration = AppConfiguration.find(params[:id])
        render json: app_configuration
      end

      def create
        app_configuration = AppConfiguration.new(app_configuration_params)
        app_configuration.version = 1
        if app_configuration.save
          render json: app_configuration, status: :created
        else
          render json: { errors: app_configuration.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        app_configuration = AppConfiguration.find(params[:id])
        if app_configuration.update(app_configuration_params)
          render json: app_configuration
        else
          render json: { errors: app_configuration.errors.full_messages }, status: :unprocessable_entity
        end
      end


      # API endpoint for simulating shipping cost calculation
      def simulate_shipping
        config = AppConfiguration.find_by(name: 'shipping_rules')
        order_total = params[:order_total].to_f

        if config.nil?
          return render json: { error: "No shipping rules found." }, status: 404
        end

        begin
          service = ShippingRuleService.new(config.config_data)
          shipping_cost = service.shipping_cost(order_total)
          render json: { shipping_cost: shipping_cost }
        rescue => e
          render json: { error: "Internal error: #{e.message}" }, status: 500
        end
      end


      private

      def app_configuration_params
        params.require(:app_configuration).permit(:name, :config_data)
      end
    end
  end
end
