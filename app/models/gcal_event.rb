# frozen_string_literal: true
class GcalEvent < ApplicationRecord
  include Google::Apis::CalendarV3
  SCOPES = ['https://www.googleapis.com/auth/calendar'].freeze

  attr_accessor :event_object
  belongs_to :google_calendar
  belongs_to :batch
  after_create :delayed_calendar_save!
  after_touch :delayed_calendar_save!
  before_destroy do |cal|
    DeleteGcalEventJob.perform_later(cal.event_id)
  end

  COLOR_IDS = {
    scheduled: '9',
    confirmed: '1',
    started: '7',
    qa: '2',
    accepted: '10',
    shipped: '8',
    rejected: '4',
    awaiting_confirmation: '3'
  }.freeze

  def color
    return '11' if jeopardy_color?

    COLOR_IDS[batch.current_state.name] || '8'
  end

  def jeopardy_color?
    scheduled_in_the_past? || started_but_not_finished?
  end

  def scheduled_in_the_past?
    batch.production_date < 1.days.ago && batch.scheduled?
  end

  def started_but_not_finished?
    batch.production_date < 4.days.ago && batch.started?
  end

  default_value_for(:google_calendar) { GoogleCalendar.first }

  def delayed_calendar_save!
    SaveGcalEventJob.perform_later(self)
  end

  def delete_calendar_event!(event_id)
    if disabled?
      Rails.logger.warn 'Not deleting event because API calls are disabled.'
    else
      calendar_service.delete_event google_calendar.calendar_id, event_id
    end
  end

  def save_to_calendar!
    if disabled?
      Rails.logger.warn 'Not saving event because API calls are disabled.'
    elsif event_id.present?
      self.event_object = update_event
    else
      self.event_object = insert_event
      update event_id: event_object.id
    end
  end

  def build_calendar_event
    event = Event.new(location: '14.470803,121.043405 (Radical Kitchen)',
                      summary: event_summary,
                      start: start_time,
                      end: start_time,
                      description: description,
                      color_id: color)

    event.id = event_id if event_id.present?
    event
  end

  private

  def event_summary
    "#{batch.workflow_state.titleize}: #{batch.batch_number} #{batch.flavor.name}"
  end

  def start_time
    EventDateTime.new(date: batch.production_date.strftime('%Y-%m-%d'))
  end

  def disabled?
    GoogleCalendar.none? ||
      Rails.application.config.x.google_calendar_api.disabled == true
  end

  def calendar_service
    @calendar_service ||= lambda do
      calendar_service = CalendarService.new
      calendar_service.authorization = Google::Auth.get_application_default(SCOPES)
      calendar_service
    end.call
  end

  def description
    <<-EOF
Currently in "#{batch.workflow_state.titleize}" state.

Using #{batch.gross_fresh_primary_ingredient} kilos of primary_ingredient,
#{batch.amount_of_primary_ingredient} nonzero_or_empty_error to harvest.

http://#{ENV['HOST_NAME']}/batches/#{batch.batch_number}

    EOF
  end

  def update_event
    calendar_service.update_event google_calendar.calendar_id,
                                  event_id,
                                  build_calendar_event
  end

  def insert_event
    calendar_service.insert_event google_calendar.calendar_id,
                                  build_calendar_event
  end
end
