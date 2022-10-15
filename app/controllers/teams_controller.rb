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
    @team = @game.teams.create
    if @team.save
      redirect_to game_url(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to game_url(@game) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
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
