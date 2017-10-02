class CreateLeagues < ActiveRecord::Migration[4.2]
  def change
    create_table :leagues do |t|

      t.string :name
      t.string :description
      t.string :password_digest
      t.datetime :created_at

      t.integer :creator_id
    end
  end
end
