# frozen_string_literal: true
class GoogleCalendar < ApplicationRecord
  include Google::Apis::CalendarV3

  attr_accessor :gcal

  has_many :gcal_events, dependent: :delete_all
  has_and_belongs_to_many :users,
                          after_add: :delayed_give_user_access,
                          before_add: :reject_users_if_not_saved_to_google,
                          after_remove: :delayed_remove_user_access

  before_destroy :delete_from_google
  before_create :save_to_google!, unless: :calendar_id?

  def delayed_remove_user_access(user)
    RemoveUserAccessToCalendarJob.perform_later(self, user)
  end

  def share_link
    "https://calendar.google.com/calendar/ical/#{calendar_id}/public/basic.ics"
  end

  def delayed_give_user_access(user)
    GiveUserAccessToCalendarJob.perform_later(self, user)
  end

  def reject_users_if_not_saved_to_google(_user)
    raise 'Please save to Google before adding users to calendar' unless calendar_id.present?
  end

  def remove_user_access(user)
    calendar_service.delete_acl calendar_id, "user:#{user.email}"
  end

  def give_user_access(user)
    acl_rule = AclRule.new role: 'reader',
                           scope: {
                             type: 'user',
                             value: user.email
                           }
    calendar_service.insert_acl calendar_id, acl_rule
  end

  def give_user_owner_access(user)
    acl_rule = AclRule.new role: 'owner',
                           scope: {
                             type: 'user',
                             value: user.email
                           }
    calendar_service.insert_acl calendar_id, acl_rule
  end

  LOCATION = '14.470803,121.043405 (Radical Kitchen, Cervantes Compound, Parañaque, Metro Manila)'
  default_value_for :time_zone, 'Asia/Manila'
  default_value_for :title, 'Manufacturing Manila Production Calendar'
  default_value_for :description, 'Calendar For Managers To Oversee Production Activities.'
  default_value_for :location, LOCATION

  def save_to_google!
    calendar = build_calendar
    if calendar_id.nil?
      self.gcal = calendar_service.insert_calendar calendar
      self.calendar_id = gcal.id
      save if persisted?
    else
      calendar_service.update_calendar calendar_id, calendar
    end
  end

  def build_calendar
    cal = Calendar.new(
      summary: title,
      title: title,
      time_zone: time_zone,
      # description: description,
      location: location
    )
    cal.id = calendar_id if calendar_id.present?
    cal
  end

  private

  def delete_from_google
    calendar_service.delete_calendar calendar_id
  end

  def calendar_service
    @calendar_service ||= lambda do
      calendar_service = CalendarService.new
      authorization = Google::Auth.get_application_default(GcalEvent::SCOPES)
      calendar_service.authorization = authorization
      calendar_service
    end.call
  end
end
