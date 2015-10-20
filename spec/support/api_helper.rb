module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def response_json
    MultiJson.load(last_response.body, symbolize_keys: true)
  end

  def api_token_header(user)
    team = user.teams.first
    token = ApiToken.for(user, team)
    { "X_API_TOKEN" => token.token }
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :api
end
