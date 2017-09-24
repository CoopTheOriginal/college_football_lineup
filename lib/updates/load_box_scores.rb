module Updates
  class LoadBoxScores
    def load
      # TODO: Remove limit of 1
      Game.not_finished.where('start_date <= ?', Date.current).limit(2).each do |game|
        box_score = retrieve_box_score(game)
        next unless box_score

        game_stats = stats_tables(box_score)
        save_passing(game_stats, game, 'passing_home', game.home)
        # save_passing(game_stats, game, 'passing_visiting', game.away)
      end
    end

    private def retrieve_box_score(game)
      endpoint = game.link.gsub('gameinfo', 'boxscore')
      Ncaa.new(endpoint).response
    end

    private def stats_tables(resp)
      resp['tables'].map { |h| [h['id'], h] }.to_h
    end

    private def save_passing(stats, game, category, team)
      Statline.new(stats[category]).stats.each do |player_name, stat_line|
        player = get_create_player(player_name, team)

        Stat.create(
          pass_attempts: stat_line['CP-ATT-INT'].split('-').second,
          pass_completions: stat_line['CP-ATT-INT'].split('-').first,
          pass_yards: stat_line['YDS'],
          pass_touchdowns: stat_line['TD'],
          interceptions: stat_line['CP-ATT-INT'].split('-').last,
          game_id: game.id,
          player_id: player.id
        )
      end
    end

    private def get_create_player(player_name, team)
      Player.find_or_create_by(
        year: Date.current.year,
        name: player_name,
        team_id: team.id
      )
    end
  end
end
