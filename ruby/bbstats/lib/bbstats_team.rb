
module BBStats

  class Team

    attr_reader :team_id, :year, :at_bats, :singles, :doubles, :triples, :homers

    def initialize(id, y)
      @team_id, @year, @player_ids = id.to_s, y.to_s.to_i, {}
      @at_bats, @singles, @doubles, @triples, @homers = 0, 0, 0, 0, 0
    end

    def aggregate_batter(b)
      if b
        @at_bats = @at_bats + b.at_bats
        @singles = @singles + b.singles
        @doubles = @doubles + b.doubles
        @triples = @triples + b.triples
        @homers  = @homers  + b.homers

        demo = BBStats::Datastore.lookup_player_demographic(b.player_id)
        if demo
          @player_ids[b.player_id] = demo.full_name
        else
          @player_ids[b.player_id] = '?'
        end
      end
    end

    def slugging_pct
      ((singles + (doubles * 2) + (triples * 3) + (homers * 4)).to_f / at_bats.to_f) * 1000.0
    end

  end

end
