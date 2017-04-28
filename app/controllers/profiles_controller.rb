class ProfilesController < ApplicationController

  def index
    @profiles = current_user.profiles
  end

  def edit
    @profiles = current_user.profiles
    @profile = current_user.profiles.find(params[:id])
  end

  def update
    @profile = current_user.profiles.find(params[:id])
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to edit_profile_path(@profile), notice: 'Profile was successfully updated.' }
        # format.json { render :show, status: :ok, location: @post }
      else
        @profiles = current_user.profiles
        format.html { render :edit }
        # format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:default_interval, :default_interval_type)
  end
end
