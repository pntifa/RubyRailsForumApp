Rails.application.routes.draw do
  resources :posts
  devise_for :users, :controllers => {:registrations => "registrations"}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  root to: 'pages#index'

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end

  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
  end

  resources :posts, only: [:show] do
    collection do
      get 'hobby'
      get 'study'
      get 'team'
    end
  end

  namespace :private do 
    resources :conversations, only: [:create] do
      member do
        post :close
      end
    end
    resources :messages, only: [:index, :create]
  end

  resources :contacts, only: [:create, :update, :destroy]

  namespace :group do 
    resources :conversations do
      member do
        post :close
        post :open
      end
    end
    resources :messages, only: [:index, :create]
  end

  get 'messenger', to: 'messengers#index'
  get 'get_private_conversation', to: 'messengers#get_private_conversation'
  get 'get_group_conversation', to: 'messengers#get_group_conversation'
  get 'open_messenger', to: 'messengers#open_messenger'
  # Defines the root path route ("/")
  # root "posts#index"
end
