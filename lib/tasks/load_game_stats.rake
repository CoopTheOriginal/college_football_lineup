namespace :load_game_stats do
  desc 'Load game info for the current week'
  task load: :environment do
    Updates::LoadGameStats.new.load
  end
end
