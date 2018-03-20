# frozen_string_literal: true
class BatchConfirmationMailer < ApplicationMailer
  DATE_FORMAT = '%A %b %d'
  def send_confirmation(batch)
    @batch    = batch
    @subject  = "Batch Confirmation Request: #{batch.batch_number} #{batch.flavor.name}"
    @recipients = User.manager.where(receive_confirmation_mailings: true).pluck(:email)
    mail to: @recipients, subject: @subject
  end

  def send_approval_request(batch)
    @users    = User.admin
    @batch    = batch
    @subject  = "Confirmation Request for #{batch.production_date.strftime(DATE_FORMAT)}"
    mail to: (@users.pluck(:email) + ['tyler@manufacturing.com']).uniq, subject: @subject
  end
end
