# frozen_string_literal: true
require 'administrate/field/base'

class PaperclipAttachmentField < Administrate::Field::Base
  def url
    data.expiring_url(10)
  end

  def to_s
    data
  end

  def present?
    data.instance.send "#{data.attribute}?"
  end
end
