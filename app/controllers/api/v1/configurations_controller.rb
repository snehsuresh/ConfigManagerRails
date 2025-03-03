# app/controllers/api/v1/configurations_controller.rb
module Api
  module V1
    class AppConfigurationsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def index
        configurations = Configuration.all
        render json: configurations
      end

      def show
        configuration = Configuration.find(params[:id])
        render json: configuration
      end

      def create
        configuration = Configuration.new(configuration_params)
        configuration.version = 1
        if configuration.save
          render json: configuration, status: :created
        else
          render json: { errors: configuration.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        configuration = Configuration.find(params[:id])
        configuration.version += 1
        if configuration.update(configuration_params)
          render json: configuration
        else
          render json: { errors: configuration.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def configuration_params
        params.require(:app_configuration).permit(:name, :config_data)
      end
    end
  end
end
