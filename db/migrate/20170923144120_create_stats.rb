class CreateStats < ActiveRecord::Migration[4.2]
  def change
    create_table :stats do |t|
      t.integer :pass_attempts
      t.integer :pass_completions
      t.integer :pass_yards
      t.integer :pass_touchdowns
      t.integer :interceptions

      t.integer :rush_attempts
      t.integer :rush_yards
      t.integer :rush_touchdowns

      t.integer :receptions
      t.integer :receiving_yards
      t.integer :receiving_touchdowns

      t.integer :kicker_points

      t.integer :predicted

      t.belongs_to :player, index: true
      t.belongs_to :game, index: true
    end
  end
end
