class Pokemon < ApplicationRecord
  belongs_to :team, touch: true
  validates :pokedex_id, numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: 898} # TODO Will need updated when new pokemon are available 
  belongs_to :link_row

  # TODO: CSV Export feature just to get pokemon names, pokedex id, and links?

end
