class LinkRow < ApplicationRecord
  has_many :pokemons, dependent: :destroy
end
