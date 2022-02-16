class Game < ApplicationRecord
  validates :room_id, length: { in: 7..20 }, format: { with: /\A[A-Za-z0-9_]{7,}\z/, message: "only allows A-Z a-z 0-9" }
  #before_validation :create_slug, on: :create
  has_many :teams, dependent: :delete_all

  def self.create_slug
    characters = Array("A".."Z") + Array("a".."z") + Array("0".."9")
    str = characters.sample(7).join
    return str
  end

    # TODO Allow params room_id. check for game with room id and if last access/update > threshold, overwrite
end
