class CreateUsageStats < ActiveRecord::Migration[6.0]
  def change
    create_table :usage_stats do |t|
      t.integer :gamesWithMultiplePokemon, null: false
      t.integer :gamesWithMultipleTeams, null: false
      t.integer :gamesWithAtLeastOnePokemon, null: false

      t.timestamps
    end
  end
end
