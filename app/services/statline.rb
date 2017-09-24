class Statline
  attr_accessor :raw, :headers, :stats

  def initialize(raw_stat_hash)
    @raw = raw_stat_hash
    @headers = generate_headers
    @stats = {}

    append_stats
  end

  private def generate_headers
    raw['header'][1..-1].map { |x| x['display'] }
  end

  private def append_stats
    rows = only_player_rows

    rows.each do |row|
      player_name = row['row'].first['display'].strip
      stat_line = row['row'][1..-1].map { |x| x['display'] }

      @stats[player_name] = Hash[headers.zip(stat_line)]
    end
  end

  private def only_player_rows
    raw['data'].select { |row| valid_row?(row) }
  end

  private def valid_row?(row)
    row['row'].any? && row['row'].first['display'] != 'Total'
  end
end
