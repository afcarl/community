
module BBStats

  class Calculator

    attr_reader :options, :error

    def initialize(opts={})
      @options = opts
      @error = BBStats::Datastore.load(options)
    end

    def error?
      (error.nil?) ? false : true
    end

    def verbose?
      options[:verbose]
    end

    def calc_most_improved_avg
      curr_year = options[:year].to_i
      prev_year = curr_year.to_i - 1
      puts "calc_most_improved_avg #{curr_year} vs #{prev_year}" if verbose?
      most_improved, largest_diff = {}, 0.0

      unless error?
        BBStats::Datastore.sorted_batter_ids.each_with_index do | id, idx |
          batter_curr = BBStats::Datastore.batter_for_year(id, curr_year)
          batter_prev = BBStats::Datastore.batter_for_year(id, prev_year)
          if batter_curr && batter_prev
            if batter_curr.has_min_at_bats? && batter_prev.has_min_at_bats?
              batting_avg_diff = batter_curr.batting_average - batter_prev.batting_average
              if batting_avg_diff > largest_diff
                most_improved[:curr] = batter_curr
                most_improved[:prev] = batter_prev
                most_improved[:diff] = batting_avg_diff
                most_improved[:demo] = BBStats::Datastore.lookup_player_demographic(id)
                largest_diff = batting_avg_diff
                puts "most improved is now: #{id} #{batting_avg_diff}" if verbose?
              end
            end
          end
        end
      end
      most_improved
    end

    def calc_slugging_pct_for_team
      team_id, year = options[:team], options[:year].to_i
      team = BBStats::Team.new(team_id, year)
      results = { :team_id => team_id, :year => year, :team => team, :spct => 0.0 }
      unless error?
        BBStats::Datastore.batters.each do | b |
          if b.is_team?(team_id) && b.is_year?(year)
            team.aggregate_batter(b)
          end
        end
      end
      results[:spct] = team.slugging_pct
      results
    end

    def identify_triple_crown_winners
      year, mlb_results = options[:year].to_i, []
      unless error?
        BBStats::Datastore.leagues.each do | league |
          highs = { :avg => 0, :rbi => 0, :homers => 0 }
          league_results = { :year => year, :league => league, :highs => highs, :winner => nil, :demo => nil }
          BBStats::Datastore.batters.each do | b |
            if b.in_league?(league) && b.is_year?(year) && b.has_min_at_bats?(400)
              if (b.batting_average > highs[:avg])
                highs[:avg]    = b.batting_average
                highs[:avg_id] = b.player_id
              end
              if (b.rbi > highs[:rbi])
                highs[:rbi]    = b.rbi
                highs[:rbi_id] = b.player_id
              end
              if (b.homers > highs[:homers])
                highs[:homers]    = b.homers
                highs[:homers_id] = b.player_id
              end
            end
          end

          id1, id2, id3 = highs[:avg_id], highs[:rbi_id], highs[:homers_id]
          if (id1.size > 0) && (id1.eql? id2) && (id1.eql? id3)
            league_results[:winner] = id1
            league_results[:demo]   = BBStats::Datastore.lookup_player_demographic(id1)
            mlb_results << league_results
          end
        end
      end
      mlb_results
    end

  end

end
