Rails.application.routes.draw do
  root 'posts#index'

  get 'categories/export', to: 'categories#export'
  get 'categories/import', to: 'categories#import'
  post 'categories/import', to: 'categories#import_file'
  get 'posts/export', to: 'posts#export'
  get 'posts/import', to: 'posts#import'
  post 'posts/import', to: 'posts#import_file'
  resources :posts do
    get '/page/:page', action: :index, on: :collection
  end
  resources :users, only: %i[new create]
  resources :categories


  # get 'users/new'
  # get 'users/create'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'welcome', to: 'sessions#welcome'
  delete '/logout',  to: 'sessions#destroy'
  get 'authorized', to: 'sessions#page_requires_login'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
