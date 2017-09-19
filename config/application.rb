require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module TodoApp
  class Application < Rails::Application
    config.api_only = true
    config.middleware.use ActionDispatch::Flash
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.assets.initialize_on_precompile = false
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 expose:  %w(access-token expiry token-type uid client),
                 methods: %i(get post options patch delete put)
      end
    end
  end
end
