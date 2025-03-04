class AppConfigurationsController < ApplicationController
  before_action :set_app_configuration, only: [:show, :edit, :update, :destroy]
  
  def index
    @app_configurations = AppConfiguration.all
  end

  def show
  end

  def new
    @app_configuration = AppConfiguration.new
  end

  def create
    @app_configuration = AppConfiguration.new(app_configuration_params)
    @app_configuration.version = 1  # Initial version
    if @app_configuration.save
      redirect_to app_configurations_path, notice: 'Configuration created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @app_configuration.assign_attributes(app_configuration_params)

    # Force bump the version — directly bypass the method
    @app_configuration[:version] = (@app_configuration[:version].to_i + 1)

    if @app_configuration.save
      redirect_to app_configurations_path, notice: 'Configuration updated successfully.'
    else
      render :edit
    end
  end




  def destroy
    @app_configuration.destroy
    redirect_to app_configurations_path, notice: 'Configuration deleted successfully.'
  end

  private

  def set_app_configuration
    @app_configuration = AppConfiguration.find(params[:id])
  end

  # **Do not permit :version here!**
  def app_configuration_params
    params.require(:app_configuration).permit(:name, :config_data).tap do |whitelisted|
      if whitelisted[:config_data].is_a?(String)
        whitelisted[:config_data] = JSON.parse(whitelisted[:config_data])
      end
    end
  end
end
