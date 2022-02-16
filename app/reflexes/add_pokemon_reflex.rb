# frozen_string_literal: true

class AddPokemonReflex < ApplicationReflex
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
    @game = Game.includes(:teams).find_by(room_id: room_id)

    # TODO Some sort of form for this really
    
    pokemons = []
    channel_name = "game-#{room_id}"

    link_row = LinkRow.create
    @game.teams.each do |team|
      unless team.pokemons.count >= 100
        pokemon = team.pokemons.create(nickname: "", pokedex_id: 1, is_alive: true, link_row_id: link_row.id)
        pokemons.push(pokemon)
      end
    end

    cable_ready[channel_name].outer_html(
      selector: ".teams-container",
      html: GamesController.render(partial: "teams", locals: {teams: @game.teams})
    )
    cable_ready[channel_name].broadcast
  end

end
