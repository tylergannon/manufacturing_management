# frozen_string_literal: true
class IssueMailer < ApplicationMailer
  # from "Manufacturing Mailer (Do Not Reply) <do-not-reply@manufacturing.com>"
  def issue_notification(batch, requested_by)
    @issue = batch.issues.current
    @batch = batch
    @requested_by = requested_by
    @subject = "Production Issue: Batch #{@batch.batch_number}"
    mail to: recipients, subject: @subject
  end

  def recipients
    if Rails.application.config.x.mail_recipients&.any?
      Rails.application.config.x.mail_recipients
    elsif User.where(receive_issue_mailings: true).any?
      User.where(receive_issue_mailings: true).map(&:email)
    else
      ['foo@bar.com']
    end
  end
end
