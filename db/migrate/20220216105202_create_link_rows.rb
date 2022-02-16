class CreateLinkRows < ActiveRecord::Migration[6.0]
  def change
    create_table :link_rows do |t|
    end

    change_table :pokemons do |t|
      t.references :link_row, foreign_key: true
    end
  end
end
