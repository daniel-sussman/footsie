Rails.application.routes.draw do
  devise_for :players
  get 'games/index'
  get 'games/show'
  get 'games/new'
  get 'games/create'
  get 'games/edit'
  get 'games/update'
  get 'games/destroy'
  # root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "games#index"
  resources :games do
    resources :player_games, only: [:create, :destroy]
  end
  resources :players, only: [:show, :new, :create]
  resources :player_games, only: [:leave]
end
