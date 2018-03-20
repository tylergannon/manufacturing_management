# frozen_string_literal: true
module AsanaApi
  def api_client
    @api_client ||= Asana::Client.new do |c|
      c.authentication :access_token, ENV['ASANA_ACCESS_TOKEN']
    end
  end
end
