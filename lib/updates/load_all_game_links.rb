module Updates
  class LoadAllGameLinks
    WEEKS = 15

    def load
      Array(1..WEEKS).each do |week|
        puts "Loading games for week: #{week}"
        endpoints = game_info_endpoints(week)
        endpoints.each { |x| create_game(x, week) }
      end
    end

    private def game_info_endpoints(week)
      resp = Ncaa.new(scoreboard(week)).response
      resp['scoreboard'].map { |d| d['games'] }.flatten
    end

    private def scoreboard(week)
      week = "0#{week}" if week.digits.length == 1
      year = Date.current.year
      "/sites/default/files/data/scoreboard/football/fbs/#{year}/#{week}/scoreboard.json"
    end

    private def create_game(endpoint, week)
      return if Game.find_by(link: endpoint)

      info = Ncaa.new(endpoint).response

      Game.create(
        link: endpoint,
        start_date: Date.parse(info['startDate']),
        start_time: Time.at(info['startTimeEpoch'].to_i),
        home_id: find_create_team(info, 'home').id,
        home_rank: info['home']['teamRank'].to_i,
        home_score: info['home']['currentScore'].to_i,
        away_id: find_create_team(info, 'away').id,
        away_rank: info['away']['teamRank'].to_i,
        away_score: info['away']['currentScore'].to_i,
        location: info['location'],
        status: 'pending',
        week: week
      )
    end

    private def find_create_team(response, home_away)
      Team.find_or_initialize_by(name: response[home_away]['nameRaw']).tap do |team|
        team.short_name = response[home_away]['shortname']
        team.save
      end
    end
  end
end
