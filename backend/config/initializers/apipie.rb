Apipie.configure do |config|
  config.app_name     = "Seshook Api"
  config.api_base_url = "/api"
  config.doc_base_url = "/apidoc"
  config.copyright    = "&copy; 2015 Seshook"
  config.validate     = false
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
end
