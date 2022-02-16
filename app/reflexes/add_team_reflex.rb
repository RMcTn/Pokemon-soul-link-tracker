# frozen_string_literal: true

class AddTeamReflex < ApplicationReflex
  # Add Reflex methods in this file.
  #
  # All Reflex instances expose the following properties:
  #
  #   - connection - the ActionCable connection
  #   - channel - the ActionCable channel
  #   - request - an ActionDispatch::Request proxy for the socket connection
  #   - session - the ActionDispatch::Session store for the current visitor
  #   - url - the URL of the page that triggered the reflex
  #   - element - a Hash like object that represents the HTML element that triggered the reflex
  #   - params - parameters from the element's closest form (if any)
  #
  # Example:
  #
  #   def example(argument=true)
  #     # Your logic here...
  #     # Any declared instance variables will be made available to the Rails controller and view.
  #   end
  #
  # Learn more at: https://docs.stimulusreflex.com

  def add(room_id)
    @game = Game.find_by(room_id: room_id)
    teams_count = @game.teams.count
    unless teams_count >= 6
      @team = @game.teams.create
      pokemon_count = @game.teams.first.pokemons.count
      
      channel_name = "game-#{room_id}"
      @game.teams.first.pokemons.each do |temp_pokemon|
        unless @team.pokemons.count >= 100
          link_row_id = temp_pokemon.link_row_id
          @pokemon = @team.pokemons.create(nickname: "", pokedex_id: 1, link_row_id: link_row_id, is_alive: temp_pokemon.is_alive?, is_boxed: temp_pokemon.is_boxed?)
        end
      end

      cable_ready[channel_name].insert_adjacent_html(
        # TODO This likely needs a specific id (use team id on the selector?)
        selector: ".teams-container",
        html: GamesController.render(partial: "team", locals: {team: @team, i: teams_count})
      )
      cable_ready[channel_name].remove(
        selector: ".info"
      )
      cable_ready[channel_name].broadcast
    end

  end

end
