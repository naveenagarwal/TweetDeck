class OmniauthSessionController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    request_auth = request.env['omniauth.auth']
    return redirect_to new_user_session_path,
      error: "Didn't get the email from provider" if email_blank?(request_auth)

    @user = User.find_by(email: @email)
    if @user.blank?
      register(@email, request_auth)
    elsif !@user.profiles.where(provider: params[:provider]).exists?
      create_profile(request_auth)
    end

    return redirect_to new_user_session_path,
      error: "Error - #{@user.errors.full_messages.join(", ")}, \
        #{@profile.errors.full_messages.join(", ")}," if any_error?
    byebug
    sign_in_and_redirect(@user)
  end

  private

  def email_blank?(request_auth)
    @email = request_auth.try(:extra).try(:raw_info).try(:email)
    @email.blank?
  end

  def register(email, request_auth)
    friendly_token = Devise.friendly_token
    @user = User.create(
      email: email,
      password: friendly_token,
      password_confirmation: friendly_token
    )

    # return redirect_to new_user_session_path,
    #   error: "Failed to register - #{@user.errors.full_messages.join(", ")}" unless @user.persisted?

    create_profile(request_auth)
  end

  def create_profile(request_auth)
    @profile = @user.profiles.create(
        provider: params[:provider],
        token: request_auth.credentials.token,
        secret: request_auth.credentials.secret,
        access_token: request_auth.extra.access_token.token,
        uid: request_auth.uid,
        name: request_auth.info.name
      )

    # return redirect_to new_user_session_path,
    #   error: "Failed to create profile - #{@profile.errors.full_messages.join(", ")}" unless @profile.persisted?
  end

  def any_error?
    @user.errors.present? || @profile.try(:errors).present?
  end
end


