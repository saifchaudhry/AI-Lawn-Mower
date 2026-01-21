Rails.application.routes.draw do
  devise_for :users

  # Health check
  get '/health', to: proc { [200, { 'Content-Type' => 'text/plain' }, ['OK']] }

  # Get quotes - redirects to locations for now
  get '/get-quotes', to: 'locations#index', as: :get_quotes

  # Join as pro - placeholder for now
  get '/join-as-pro', to: 'pages#home', as: :join_as_pro

  # Locations and nested shops
  resources :locations, only: [:index], param: :slug
  get '/:slug', to: 'locations#show', as: :location

  scope '/:location_slug', as: :location do
    resources :shops, only: [:index, :show]
  end

  root "pages#home"
end
