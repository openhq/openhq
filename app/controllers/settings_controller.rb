class SettingsController < ApplicationController
  def edit
    @settings = Settings.load
    authorize!(:update, @settings)
  end

  def update
    @settings = Settings.load
    authorize!(:update, @settings)

    if @settings.update(settings_params)
      redirect_to root_path, notice: "Your settings have been updated"
    else
      render :edit
    end
  end

  private

  def settings_params
    params.require(:settings).permit(:organisation_name)
  end
end
