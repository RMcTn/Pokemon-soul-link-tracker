class Team < ApplicationRecord
  belongs_to :game, touch: true
  has_many :pokemons, dependent: :delete_all

  scope :order_by_id, -> { order(:id) }

end
