class Game < ApplicationRecord
  belongs_to :home, class_name: 'Team'
  belongs_to :away, class_name: 'Team'

  delegate :name, to: :home, prefix: true
  delegate :short_name, to: :home, prefix: true
  delegate :name, to: :away, prefix: true
  delegate :short_name, to: :away, prefix: true

  enum status: [:finished, :canceled, :pending, :postponed]

  scope :finished, -> { where.not(status: 'pending') }
  scope :not_finished, -> { where.not(status: 'finished') }
  scope :current_season, -> { where('start_date > ?', Date.current.beginning_of_year) }
end
