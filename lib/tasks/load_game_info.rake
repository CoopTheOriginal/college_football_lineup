namespace :load_game_info do
  desc 'Load non-finished game information'
  task load: :environment do
    Updates::LoadGameInfo.new.load
  end
end
