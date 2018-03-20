# frozen_string_literal: true
class Photo < ApplicationRecord
  belongs_to :batch_feedback
  belongs_to :owner, required: true, polymorphic: true, touch: true

  def as_json(*_args)
    {
      id: id,
      owner_id: owner_id,
      owner_type: owner_type,
      flavor1_file_name: photo.flavor1_filename,
      flavor1: photo.expiring_url(60),
      small: photo.expiring_url(60, :small),
      medium: photo.expiring_url(60, :medium),
      large: photo.expiring_url(60, :large)
    }
  end

  CONTENT_TYPES = %w(image/jpg image/png image/gif image/bmp image/jpeg image/tiff).freeze

  concerning :Attachments do
    included do
      S3_CONFIG = {
        storage: :s3,
        url: ':s3_domain_url',
        s3_permissions: :private,
        path: 'uploads/photos/:id.:style.:extension',
        styles: {
          small: ['150x150', :png],
          medium: ['300x300', :png],
          large: ['600x600', :png]
        },
        s3_credentials: {
          access_key_id: ENV['S3_KEY'],
          secret_access_key: ENV['S3_SECRET']
        },
        s3_region: ENV['S3_REGION'],
        bucket: ENV['S3_BUCKET'],
        default_url: :missing_image_path
      }

      has_attached_file :photo, S3_CONFIG

      validates_attachment :photo,
                           content_type: { content_type: CONTENT_TYPES }
      process_in_background :photo
    end

    def missing_image_path
      ActionController::Base.helpers.image_path('missing.png')
    end
  end
end
