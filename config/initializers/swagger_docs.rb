Swagger::Docs::Config.register_apis({
  "1.0" => {
    api_file_path: "public/",
    base_path: ENV.fetch("API_BASE_PATH", "https://example.org"),
    clean_directory: false, # delete all .json files at each generation
    attributes: {
      info: {
        "title" => "Example API v1",
        "termsOfServiceUrl" => "https://example.org/terms",
        "contact" => "hello@example.org"
      }
    }
  }
})