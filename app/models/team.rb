class Team < ApplicationRecord
  has_many :players

  def games
    Game.where(away_id: id).or(Game.where(home_id: id))
  end
end
