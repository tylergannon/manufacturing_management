# frozen_string_literal: true
json.extract! photo, :id, :batch_feedback_id, :created_at, :updated_at
json.url secure_download_photo_url(photo)
