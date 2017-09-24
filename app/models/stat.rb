class Stat < ApplicationRecord
  belongs_to :player, inverse_of: :players
end
