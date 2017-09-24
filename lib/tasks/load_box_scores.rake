namespace :load_box_scores do
  desc 'Load box scores for unfinished games'
  task load: :environment do
    Updates::LoadBoxScores.new.load
  end
end
