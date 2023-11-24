Rails.application.routes.draw do
  devise_for :players
  # root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "games#index"
  post "teams/:team_id", to: "player_teams#create", as: :join_team
  resources :games do
    collection do
      get :search
    end
    resources :reviews, only: [:new, :create]
  end
  resources :players, only: [:show, :new, :create]
  resources :player_teams, only: [:update]

end
