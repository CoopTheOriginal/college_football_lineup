namespace :load_all_game_links do
  desc 'Load all game info links one time at the start of the season'
  task load: :environment do
    Updates::LoadAllGameLinks.new.load
  end
end
