class CreatePlayers < ActiveRecord::Migration[4.2]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :position
      t.integer :year

      t.belongs_to :team, index: true
    end
  end
end
