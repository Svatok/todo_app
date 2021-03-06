Rails.application.routes.draw do
  apipie
  scope '/api', defaults: { format: 'json' } do
    mount_devise_token_auth_for 'User', at: 'auth'
    scope module: :v1, constraints: ApiVersion.new('v1', true) do
      resources :todos do
        resources :items do
          resources :comments
        end
      end
    end
  end
end
