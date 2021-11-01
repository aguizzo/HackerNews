Rails.application.routes.draw do
  resources :submissions do
    member do
      put 'upVotes'
    end
  end
  get '/submit', to: 'submissions#new', as: 'submit'
  get "/news", to:'submissions#index', as: 'news'
  get '/newest', to: 'submissions#newest'
  root 'submissions#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
