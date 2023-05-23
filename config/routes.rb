Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'landing#index'

  get '/dashboard', to: 'users#show'
  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get "/login", to: "sessions#login_form"
  post "/login", to: "sessions#login"
  get '/logout', to: 'sessions#logout'

  resources :discover, only: [:index]
  resources :movies, only: [:index, :show] do
    resources :viewing_parties, only: [:new, :create], controller: 'movies/viewing_parties'
  end
end
