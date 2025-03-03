# app/controllers/configurations_controller.rb
class AppConfigurationsController < ApplicationController
  def index
    @app_configuration = AppConfiguration.all
  end

  def new
    @app_configuration = AppConfiguration.new
  end

  def create
    @app_configuration = AppConfiguration.new(configuration_params)
    @app_configuration.version = 1
    if @app_configuration.save
      redirect_to app_configurations_path, notice: 'AppConfiguration updated successfully.'
    else
      render :new
    end
  end

  def edit
    @app_configuration = AppConfiguration.find(params[:id])
  end

  def update
    @app_configuration = AppConfiguration.find(params[:id])
    @app_configuration.version += 1
    if @app_configuration.update(configuration_params)
      redirect_to app_configurations_path, notice: 'AppConfiguration updated successfully.'
    else
      render :edit
    end
  end

  def show
    @app_configuration = AppConfiguration.find(params[:id])
  end

  private

  def configuration_params
    # Expect config_data to be a JSON string; we parse it.
    parsed_params = params.require(:app_configuration).permit(:name, :config_data)
    if parsed_params[:config_data].present?
      begin
        parsed_params[:config_data] = JSON.parse(parsed_params[:config_data])
      rescue JSON::ParserError
        @app_configuration&.errors&.add(:config_data, "Invalid JSON format")
      end
    end
    parsed_params
  end
end
