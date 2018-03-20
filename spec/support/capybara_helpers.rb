# frozen_string_literal: true
# You can read about this gist at: http://wealsodocookies.com/posts/how-to-test-facebook-login-using-devise-omniauth-rspec-and-capybara

def set_omniauth(_opts = {})
  # default = {:provider => :linkedin,
  #            :uuid     => "1234",
  #            :linkedin => {
  #                           :email => "foobar@example.com",
  #                           :gender => "Male",
  #                           :first_name => "foo",
  #                           :last_name => "bar"
  #                         }
  #           }
  #
  # credentials = default.merge(opts)
  # provider = credentials[:provider]
  # user_hash = credentials[provider]

  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:linkedin] = YAML.load_file(
    Rails.root.join('spec/support/linkedin_data_example.yml')
  )
end

def set_invalid_omniauth(opts = {})
  credentials = { provider: :facebook,
                  invalid: :invalid_crendentials }.merge(opts)

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]
end
