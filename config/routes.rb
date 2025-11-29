Rails.application.routes.draw do
  get 'users/show'
  devise_for :users
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'top#index'
  get 'how_to_play', to: 'pages#how_to_play'
  get 'game' => 'games#index'
  post '/game', to: 'games#check'
  get 'start_new_game', to: 'games#start_new_game'
end

