module Updates
  class LoadGameInfo
    def load
      Game.not_finished
        .where('start_date < ?', Date.current.weeks_since(2))
        .each { |game| update_game_info(game) }
    end

    private def update_game_info(game)
      info = Ncaa.new(game.link).response

      game.update!(
        start_date: Date.parse(info['startDate']),
        start_time: Time.at(info['startTimeEpoch'].to_i),
        home_id: find_create_team(info, 'home').id,
        home_rank: info['home']['teamRank'].to_i,
        home_score: info['home']['currentScore'].to_i,
        away_id: find_create_team(info, 'away').id,
        away_rank: info['away']['teamRank'].to_i,
        away_score: info['away']['currentScore'].to_i,
        location: info['location'],
        status: determine_status(info['finalMessage'] || info['gameState'])
      )
    end

    private def find_create_team(response, home_away)
      Team.find_or_initialize_by(name: response[home_away]['nameRaw']).tap do |team|
        team.short_name = response[home_away]['shortname']
        team.save
      end
    end

    private def determine_status(status)
      return 'finished' if status&.include?('Final')
      return 'canceled' if status == 'cancelled'
      return 'postponed' if status == 'postponed'
      'pending'
    end
  end
end
