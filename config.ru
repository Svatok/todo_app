# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

use Rack::Rewrite do
  rewrite /^(?!.*(omniauth|api|\.)).*$/, '/index.html'
end

require ::File.expand_path('../config/environment', __FILE__)

run Rails.application
