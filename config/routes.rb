Rails.application.routes.draw do
  resources :submissions
    get '/submit', to: 'submissions#new', as: 'submit'
  resources :users
    get '/login', to: 'users#new', as: 'login'

  get "/news", to:'home#index'
  root 'submissions#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
