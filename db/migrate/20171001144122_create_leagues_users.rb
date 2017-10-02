class CreateLeaguesUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :leagues_users do |t|
      t.integer :league_id
      t.integer :user_id
    end
  end
end
