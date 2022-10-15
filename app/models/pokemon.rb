class Pokemon < ApplicationRecord
  belongs_to :team, touch: true
  delegate :game, to: :team
  validates :pokedex_id, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 898 } # TODO Will need updated when new pokemon are available
  belongs_to :link_row

  attribute :nickname, :string, default: ""
  attribute :pokedex_id, :integer, default: 1
  attribute :is_alive, :boolean, default: true

  scope :alive, -> { where(is_alive: true) }
  scope :dead, -> { where(is_alive: false) }
  scope :boxed_and_alive, -> { where(is_boxed: true, is_alive: true) }
  scope :order_by_id, -> { order(:id) }

  def alive?
    is_alive
  end

  def dead?
    !alive?
  end

  def boxed?
    is_boxed
  end

  # TODO: CSV Export feature just to get pokemon names, pokedex id, and links?

  after_update_commit do
    broadcast_remove_to(game)
    if alive?
      broadcast_append_later_to(game, target: "alive-pokemons", locals: { game: game, team: team })
    elsif dead?
      broadcast_append_later_to(game, target: "dead-pokemons", locals: { game: game, team: team })
    elsif boxed?
      broadcast_append_later_to(game, target: "boxed-pokemons", locals: { game: game, team: team })
    end
  end

  after_destroy_commit { broadcast_remove_to(game) }
  after_create_commit { broadcast_append_later_to(game, locals: { game: game, team: team }) }
end
