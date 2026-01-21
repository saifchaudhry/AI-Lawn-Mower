Rails.application.routes.draw do
  devise_for :users

  # Health check route for Vercel
  get '/health', to: proc { [200, { 'Content-Type' => 'text/plain' }, ['OK']] }

  root "pages#home"
end
