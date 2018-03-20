# frozen_string_literal: true

Aws.config.update(region: ENV['S3_REGION'],
                  credentials: Aws::Credentials.new(ENV['S3_KEY'], ENV['S3_SECRET']))

Rails.application.configure do
  config.x.aws = Hashie::Mash.new(s3_credentials: {
                                    access_key_id: ENV['S3_KEY'],
                                    secret_access_key: ENV['S3_SECRET']
                                  },
                                  s3_host_alias: ENV['S3_HOST_ALIAS'],
                                  s3_region: ENV['S3_REGION'],
                                  bucket: ENV['S3_BUCKET'])

  config.x.s3_bucket = Aws::S3::Resource.new(region: ENV['S3_REGION']).bucket(ENV['S3_BUCKET'])
end
