class Player < ApplicationRecord
  belongs_to :team, inverse_of: :players

  enum position: [:quarterback, :halfback, :wide_receiver, :kicker]
end
