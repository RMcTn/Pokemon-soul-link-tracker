desc "Update games to use link_row instead of link for each pokemon"
task :migrate_links_to_link_rows => :environment do
  puts "Migrating links to link_rows..."

  games = Game.includes(:teams)
  games.each do |game|
    link_row_ids = []
    next if !game.teams.first
    game.teams.first.pokemons.count.times do 
      link_row = LinkRow.create
      link_row_ids << link_row.id
    end
    game.teams.each do |team|
      team.pokemons.order(:created_at).each_with_index do |pokemon, index|
        pokemon.update(link_row_id: link_row_ids[index])
      end
    end
  end

  puts "done."
end
