# frozen_string_literal: true
class PdfMailer < ApplicationMailer
  def daily_worksheet(production_date)
    worksheet = ::DailyWorksheet.new(production_date)
    @production_date = production_date
    filename = "Manufacturing Daily Production Worksheet #{@production_date.strftime('%Y-%m-%d')}"
    attachments[filename] = {
      mime_type: 'application/pdf',
      content: worksheet.render
    }
    mail to: User.where(receive_worksheets: true).pluck(:email), subject: filename
  end
end
