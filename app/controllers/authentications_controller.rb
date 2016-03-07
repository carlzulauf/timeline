class AuthenticationsController < ApplicationController
  def callback
    credential = TwitterCredential.from_omniauth(auth_hash)
    if current_user
      credential.authorizations.find_or_create(user_id: current_user.id)
      redirect_to root_url
    elsif credential.authentication
      set_current_user credential.authentication.user
      redirect_to root_url
    else
      set_current_user credential.create_authentication_with_new_user.user
      redirect_to root_url
    end
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
