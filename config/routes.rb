Rails.application.routes.draw do
  devise_for :users

  root "pages#home"

  resources :locations, only: [:index, :show], param: :slug

  # Nested routes for shops within locations
  scope ':location_slug', as: 'location' do
    get 'lawn-mower-repair', to: 'shops#index', as: 'shops'
    get 'lawn-mower-repair/:id', to: 'shops#show', as: 'shop'
  end

  namespace :api do
    scope ':location_slug' do
      resources :shops, only: [:index, :show]
    end
  end

  # Static pages
  get 'join-as-pro', to: 'pages#join_pro', as: 'join_as_pro'
  get 'get-quotes', to: 'pages#get_quotes', as: 'get_quotes'
end
