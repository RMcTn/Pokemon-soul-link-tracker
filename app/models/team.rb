class Team < ApplicationRecord
  belongs_to :game, touch: true
  has_many :pokemons, dependent: :delete_all

  scope :order_by_id, -> { order(:id) }

  after_update_commit { broadcast_replace_to(game, locals: {game: game}) }
  after_destroy_commit { broadcast_remove_to(game) }

end
