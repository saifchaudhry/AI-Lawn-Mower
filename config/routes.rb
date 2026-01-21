Rails.application.routes.draw do
  devise_for :users

  # Health check
  get '/health', to: proc { [200, { 'Content-Type' => 'text/plain' }, ['OK']] }

  # Locations and nested shops
  resources :locations, only: [:index], param: :slug
  get '/:slug', to: 'locations#show', as: :location

  scope '/:location_slug', as: :location do
    resources :shops, only: [:index, :show]
  end

  root "pages#home"
end
