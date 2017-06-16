Rails.application.routes.draw do
  scope '/api', defaults: { format: 'json' } do
    mount_devise_token_auth_for 'User', at: 'auth'
    scope module: :v1, constraints: ApiVersion.new('v1', true) do
      resources :todos
    end
  end
end
