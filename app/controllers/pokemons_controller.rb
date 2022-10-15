class PokemonsController < ApplicationController
  before_action :set_game
  before_action :set_team
  before_action :set_pokemon, only: %i[ show edit update destroy ]

  def index
    @pokemons = @teams.pokemon
  end

  def show

  end

  def new
    @pokemon = Pokemon.new
  end

  def create
    # Get game_id from params
    @pokemon = @team.pokemons.create
    @pokemon.link_row = LinkRow.first # TODO(reece): Temporary for now until we start creating a pokemon for each team.
    # Separate controller for that?
    # TODO(reece): Add 100 pokemon limit to a team on the model
    if @pokemon.save
      redirect_to game_url(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @pokemon.update(pokemon_params)
      redirect_to game_url(@game)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pokemon.destroy

    redirect_to game_url(@game)
  end

  private

  def set_game
    @game = Game.find_by(room_id: params[:game_room_id])
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end

  def pokemon_params
    params.require(:pokemon).permit(:game_room_id, :team_id, :nickname, :is_alive, :is_boxed)
  end
end
