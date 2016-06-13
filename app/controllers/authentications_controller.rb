class AuthenticationsController < ApplicationController
  def callback
    credential = TwitterCredential.from_omniauth(auth_hash)
    if current_user
      credential.authorizations.find_or_create(user_id: current_user.id)
    elsif credential.authentication
      set_current_user credential.authentication.user
    else
      set_current_user credential.create_authentication_with_new_user.user
    end
    redirect_to root_url
  end

  def logout
    session.destroy
    cookies.clear
    redirect_to root_url
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
