class Stat < ApplicationRecord
  belongs_to :player, inverse_of: :stats
end
