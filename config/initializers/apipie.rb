# frozen_string_literal: true

Apipie.configure do |config|
  config.app_name                = 'TodoApp'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/api/doc'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/{[!concerns/]**/*,*}.rb"
  # config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.app_info['1.0'] = 'Documentation for ToDo API'
  config.validate_value = false
end
