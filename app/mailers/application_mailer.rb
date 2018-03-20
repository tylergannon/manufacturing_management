# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: '"Manufacturing Production App" <manufacturing-bot-no-reply@manufacturing.com>'
  layout 'mailer'
end
