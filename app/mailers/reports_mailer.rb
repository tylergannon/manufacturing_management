# frozen_string_literal: true
class ReportsMailer < ApplicationMailer
  def weekly_report
    @this_week_batches = Batch.where(production_date: (24.hours.ago..7.days.from_now))
    @last_week_batches = Batch.where(production_date: (8.days.ago..24.hours.ago))
    @subject = "Production Report: Week of #{Time.zone.now.strftime('%b %-d, %Y')}"
    mail to: ['tyler@manufacturing.com'], subject: @subject
  end
end
