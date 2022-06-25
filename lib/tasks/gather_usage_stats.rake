desc "Gather usage stats"
task :gather_usage_stats => :environment do
  gamesWithAtLeastOnePokemon = Team.joins(:pokemons).select(:game_id).distinct.pluck(:game_id).count
  gamesWithMultipleTeams = Team.select(:game_id).group(:game_id).having("count(game_id) > 1").count.count
  gamesWithMultiplePokemon = Team.where(id: Pokemon.select(:team_id).group(:team_id).having("count(team_id) > 1")
                                                   .pluck(:team_id)).select(:game_id).distinct.count
  UsageStat.create(gamesWithAtLeastOnePokemon: gamesWithAtLeastOnePokemon,
                   gamesWithMultipleTeams: gamesWithMultipleTeams,
                   gamesWithMultiplePokemon: gamesWithMultiplePokemon)
end
