# frozen_string_literal: true
require 'application_responder'

# Main Application Controller
class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :js

  rescue_from CanCan::AccessDenied do |cancan_exception|
    log_access_denied_error(cancan_exception)

    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end

  before_action :authenticate_user!

  protect_from_forgery with: :exception, unless: :photo_upload?

  etag { latest_deployment }
  etag { flash unless flash.empty? }
  etag { current_user&.id }

  private

  MIN_DEPLOYMENT_TIME = DateTime.parse('1900-01-01').freeze

  def latest_deployment
    if Rails.env.production? || ENV['ETAGS']
      Deployment.latest_deployment || MIN_DEPLOYMENT_TIME
    else
      DateTime.now
    end
  end

  def photo_upload?
    is_a?(PhotosController) && request.format.json?
  end

  def admin_signed_in?
    user_signed_in? && current_user.admin?
  end

  def flash_for_request_format
    if request.format == :js
      flash.now
    else
      flash
    end
  end

  def log_access_denied_error(cancan_exception)
    Rails.logger.error "Access Denied for #{current_user&.name}" \
                       "Action: #{cancan_exception.action.inspect}" \
                       "Subject: #{cancan_exception.subject.inspect}"
  rescue StandardError => ex
    Rails.logger.error 'Error rescuing from CanCan exception!' \
                       "My error is: #{ex.message}" \
                       "CanCan error: #{cancan_exception.message}"
  end
end
