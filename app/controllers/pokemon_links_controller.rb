class PokemonLinksController < ApplicationController
  before_action :set_game
  before_action :set_pokemon, :set_link_row, only: %i[destroy update]

  def create
    @link_row = LinkRow.create
    @game.teams.each do |team|
      if team.pokemons.count < 100
        team.pokemons.create(link_row: @link_row)
      end
    end
  end

  def update
    @pokemon.update(pokemon_params)
    # TODO(reece): Need to have buttons/form for this action
    # Worst case, can create a controller/action just for updating is_alive/is_boxed and duplicate this copy logic over
    if @pokemon.is_alive_changed? || @pokemon.is_boxed_changed?
      @link_row.pokemons.each do |pokemon|
        pokemon.update(linked_pokemon_params)
      end
    end
  end

  def destroy
    # TODO(reece): add checks like only destroy if pokemon is in this game
    @link_row.destroy
  end

  private

  def set_game
    @game = Game.includes(:teams).find_by(room_id: params[:game_room_id])
  end

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end

  def set_link_row
    @link_row = @pokemon.link_row
  end

  def pokemon_params
    params.require(:pokemon).permit(:nickname, :is_alive, :is_boxed)
  end

  def linked_pokemon_params
    params.permit(:is_alive, :is_boxed)
  end
end
