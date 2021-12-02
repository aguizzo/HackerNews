Rails.application.routes.draw do
  resources :submissions do
    member do
      put 'upVotes'
    end
    
  end

  resources :submissions, except: :index do
    resources :comments, only: [:create, :edit, :update, :destroy]
    post :upvote, on: :member
  end

  resources :comments, except: :index do
    resources :comments, only: [:create, :edit, :update, :destroy]
    post :upvotec, on: :member
  end

  resources :users

  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/submit', to: 'submissions#new', as: 'submit'
  get "/news", to:'submissions#index', as: 'news'
  get '/newest', to: 'submissions#newest'
  get '/ask', to: 'submissions#ask'
  get 'user_submissions', to:'submissions#usersubmissions'
  get 'user_asks', to:'submissions#userasks'
  get 'user_voted', to:'submissions#uservoted'
  get '/signout', to: 'sessions#destroy', as: 'signout'
  get '/submissions/:id/comments', to: 'submissions#submissionComments'
  get '/users/:id/comments', to: 'comments#userComments'
  # post '/comments', to: 'comments#createComment'

  

  root 'submissions#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
