module Updates
  class LoadBoxScores
    def load
      Game.where('start_date > ?', Date.current - 2.day)
          .where('start_date <= ?', Date.current).each do |game|
        sleep(1)
        box_score = retrieve_box_score(game)
        next unless box_score

        game_stats = stats_tables(box_score)
        import_stats(game_stats, game)
      end
    end

    private def retrieve_box_score(game)
      endpoint = game.link.gsub('gameinfo', 'boxscore')
      Ncaa.new(endpoint).response
    end

    private def stats_tables(resp)
      resp['tables'].map { |h| [h['id'], h] }.to_h
    end

    private def import_stats(game_stats, game)
      Statline.new(game_stats, game).stats.each do |player_id, stat_line|
        create_player_stat(stat_line, game, player_id)
      end
    end

    private def create_player_stat(stat_line, game, player_id)
      passing = stat_line['passing_CP-ATT-INT']&.split('-')

      Stat.find_or_initialize_by(player_id: player_id, game_id: game.id)
          .tap do |stat|

        stat.pass_attempts = passing&.second
        stat.pass_completions = passing&.first
        stat.pass_yards = stat_line['passing_YDS']
        stat.pass_touchdowns = stat_line['passing_TD']
        stat.interceptions = passing&.last

        stat.rush_attempts = stat_line['rushing_ATT']
        stat.rush_yards = stat_line['rushing_YDS']
        stat.rush_touchdowns = stat_line['rushing_TD']

        stat.receptions = stat_line['receiving_REC']
        stat.receiving_yards = stat_line['receiving_YDS']
        stat.receiving_touchdowns = stat_line['receiving_TD']

        stat.kicker_points = stat_line['kicking_PTS']
        stat.save!
      end
    end
  end
end
