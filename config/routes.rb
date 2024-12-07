Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      mount Scimitar::Engine, at: '/'
    
      get    'Users',     to: 'users#index'
      get    'Users/:id', to: 'users#show'
      post   'Users',     to: 'users#create'
      put    'Users/:id', to: 'users#replace'
      patch  'Users/:id', to: 'users#update'
      delete 'Users/:id', to: 'users#destroy'
      
    end
  end
end
