# frozen_string_literal: true
module Auth
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      @user = User.find_by(email: request.env['omniauth.auth'].info.email)
      if @user.present?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to new_user_session_path
      end
    end
  end
end
