class CreateGames < ActiveRecord::Migration[4.2]
  def change
    create_table :games do |t|
      t.date :start_date
      t.time :start_time
      t.integer :home_id
      t.integer :home_rank
      t.integer :home_score
      t.integer :away_id
      t.integer :away_rank
      t.integer :away_score
      t.string :location
      t.integer :week
      t.integer :status
      t.string :link
    end
  end
end
