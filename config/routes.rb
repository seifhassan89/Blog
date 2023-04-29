Rails.application.routes.draw do
  # get 'authentication/show'
  # get 'sessions/create'
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  
  resources :roles
  resources :users do
    member do
      get 'comments'
    end
  end
  resources :comments
  resources :posts do
    resources :comments
  end
  
  post '/login', to: 'sessions#login'
  get '/auth', to: 'authentication#show'

  # Defines the root path route ("/")
  # root "articles#index"

end
