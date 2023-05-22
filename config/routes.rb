Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'landing#index'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get "/login", to: "users#login_form"
  post "/login", to: "users#login"

  resources :users, only: [:show] do
    resources :discover, only: [:index], controller: 'users/discover'
    resources :movies, only: [:index, :show], controller: 'users/movies' do
      resources :viewing_parties, only: [:new, :create], controller: 'users/movies/viewing_parties'
    end
  end
end
