class SettingsController < ApplicationController
  before_action :load_and_authorize_settings

  def edit
  end

  def update
    if @settings.update(settings_params)
      redirect_to root_path, notice: "Your settings have been updated"
    else
      render :edit
    end
  end

  private

  def load_and_authorize_settings
    @settings = Settings.load
    authorize!(:update, @settings)
  end

  def settings_params
    params.require(:settings).permit(:organisation_name)
  end

end
