
module BBStats

  class Batter

    attr_reader :row

    @@field_name_indices = {
      :player_id   => 0,
      :year        => 1,
      :league      => 2,
      :team_id     => 3,
      :games       => 4,
      :at_bats     => 5,
      :runs        => 6,
      :hits        => 7,
      :doubles     => 8,
      :triples     => 9,
      :homers      => 10,
      :rbi         => 11,
      :steals_safe => 12,
      :steals_out  => 13
    }

    def initialize(row)
      # row contains these four fields:
      # playerID,yearID,league,teamID,G,AB,R,H,2B,3B,HR,RBI,SB,CS
      @row = row
    end

    def player_id
      row[field_index(:player_id)]
    end

    def year
      row[field_index(:year)].to_s.strip.to_i
    end

    def league
      row[field_index(:league)]
    end

    def team_id
      row[field_index(:team_id)]
    end

    def games
      row[field_index(:games)].to_s.strip.to_i
    end

    def at_bats
      row[field_index(:at_bats)].to_s.strip.to_i
    end

    def runs
      row[field_index(:runs)].to_s.strip.to_i
    end

    def hits
      row[field_index(:hits)].to_s.strip.to_i
    end

    def doubles
      row[field_index(:doubles)].to_s.strip.to_i
    end

    def triples
      row[field_index(:triples)].to_s.strip.to_i
    end

    def homers
      row[field_index(:homers)].to_s.strip.to_i
    end

    def rbi
      row[field_index(:rbi)].to_s.strip.to_i
    end

    def steals_safe
      row[field_index(:steals_safe)].to_s.strip.to_i
    end

    def steals_out
      row[field_index(:steals_out)].to_s.strip.to_i
    end

    private

    def field_index(field)
      @@field_name_indices[field]
    end

  end

end
