class TeamsController < ApplicationController
  before_action :set_game
  before_action :set_team, only: %i[ show edit update destroy ]

  def index
    @teams = @game.teams
  end

  def show

  end

  def new
    @team = Team.new
  end

  def create
    # Get game_id from params
    @team = @game.teams.create(team_params)
    if @team.save
      redirect_to game_team_url(@game, @team)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to game_url(@game)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy

    redirect_to game_url(@game)
  end

  private

  def set_game
    @game = Game.find_by(room_id: params[:game_room_id])
  end

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:game_room_id, :name)
  end
end
