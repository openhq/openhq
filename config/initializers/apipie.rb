Apipie.configure do |config|
  config.app_name                = "Open HQ"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/api/docs"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  config.markup = Apipie::Markup::Markdown.new
  config.validate = false
end
