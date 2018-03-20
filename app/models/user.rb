# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  devise :rememberable, :trackable, :database_authenticatable, :recoverable,
         :timeoutable, :omniauthable, omniauth_providers: [:google_oauth2]

  default_value_for :receive_worksheets, true

  def name
    "#{first_name} #{last_name}"
  end

  enum role: { admin: 1, manager: 2, supervisor: 3 }

  default_value_for :admin, false
  has_many :batch_feedbacks, dependent: :nullify

  has_and_belongs_to_many :google_calendars

  concerning :Devise do
    def remember_me
      true
    end

    def send_devise_notification(notification, *args)
      devise_mailer.send(notification, self, *args).deliver_later
    end
  end
end
