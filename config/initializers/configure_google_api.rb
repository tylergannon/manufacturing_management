# frozen_string_literal: true
# Note that this file is configured to run before devise.rb, so that
# these configuration values are available upon devise configuration

Rails.application.configure do
  config.x.google_api_keys = Hashie::Mash.new(client_id: ENV['GOOGLE_CLIENT_ID'],
                                              client_secret: ENV['GOOGLE_CLIENT_SECRET'])
end

# https://www.linkedin.com/uas/oauth2/authorization
# query = {
#   response_type: 'code',
#   client_id: '75qf5fce9oz51r',
#   state: SecureRandom.uuid,
#   redirect_uri: 'http://localhost:3000/members/auth/linkedin/callback',
#   scope: 'r_basicprofile'
# }.to_query
# q = URI::HTTPS.build protocol: 'https://', host: 'www.linkedin.com', path: '/uas/oauth2/authorization', query: query
# puts q.to_s
