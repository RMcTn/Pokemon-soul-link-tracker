Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'games#index'
  # get '/:gameId', to: 'games#show'

  resources :games, param: :room_id do
    resources :teams do
      resources :pokemons
      resources :pokemon_links, only: %i[create destroy update]
    end
  end
end
