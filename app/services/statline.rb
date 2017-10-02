class Statline
  attr_accessor :raw, :game, :game_stats

  CATEGORIES = %w(passing rushing receiving kicking)
  TEAM_TYPES = %w(home visiting)

  def initialize(raw_stats, game)
    @raw = raw_stats
    @game = game
    @game_stats = {}
  end

  def stats
    TEAM_TYPES.each do |team_type|
      team = team_type == 'home' ? game.home : game.away
      combine_player_stats(team, team_type)
    end

    game_stats
  end

  private def combine_player_stats(team, team_type)
    CATEGORIES.each do |category|
      ind_stat_hash = raw[category + '_' + team_type]
      headers = generate_headers(ind_stat_hash, category)

      only_player_rows(ind_stat_hash).each do |row|
        player = find_player(row, team)
        player_stats = Hash[headers.zip(stat_line(row))]
        add_to_game_stats(player, player_stats)
      end
    end
  end

  private def generate_headers(stat_hash, category)
    stat_hash['header'][1..-1].map { |x| category + '_' + x['display'] }
  end

  private def only_player_rows(stat_hash)
    stat_hash['data'].select { |row| valid_row?(row) }
  end

  private def valid_row?(row)
    row['row'].any? && row['row'].first['display'] != 'Total'
  end

  private def find_player(row, team)
    Player.find_or_create_by(
      year: Date.current.year,
      name: row['row'].first['display'].strip,
      team_id: team.id
    )
  end

  private def stat_line(row)
    row['row'][1..-1].map { |x| x['display'] }
  end

  private def add_to_game_stats(player, player_stats)
    return game_stats[player.id] = player_stats unless game_stats[player.id]

    game_stats[player.id] = game_stats[player.id].merge(player_stats)
  end
end
