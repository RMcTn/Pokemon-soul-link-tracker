class PokemonLinksController < ApplicationController
  before_action :set_game
  before_action :set_link_row, only: :destroy

  def create
    @link_row = LinkRow.create
    @game.teams.each do |team|
      if team.pokemons.count < 100
        team.pokemons.create(link_row: @link_row)
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

  def set_link_row
    @pokemon = Pokemon.find(params[:id])
    @link_row = @pokemon.link_row
  end

end
