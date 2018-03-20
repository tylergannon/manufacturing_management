# frozen_string_literal: true
module Auth
  class PasswordsController < Devise::PasswordsController
    skip_before_action :require_no_authentication, only: :create, if: :admin_signed_in?
  end
end
