require 'bbstats'

namespace :bbstats do

  def command_line_arg(name, default_value)
    (ENV[name]) ? ENV[name] : default_value
  end

  def opts
    hash = {}
    hash[:batting_csv]     = command_line_arg('bfile', BBStats::DEFAULT_BATTING_CSV)
    hash[:pitching_csv]    = command_line_arg('pfile', BBStats::DEFAULT_PITCHING_CSV)
    hash[:demographic_csv] = command_line_arg('dfile', BBStats::DEFAULT_DEMOGRAPHIC_CSV)
    hash[:team]            = command_line_arg('team', '')
    hash[:year]            = command_line_arg('year', 2014)
    hash[:verbose]         = command_line_arg('verbose', '').downcase == 'true'
    hash
  end

  namespace :batting do

    desc 'Calculate the most improved batting average for a given year'
    task :calc_most_improved_avg do
      c = BBStats::Calculator.new(opts)
      result = c.calc_most_improved_avg
      if result
        puts "Batter with the most improved batting average is"
        puts "  name:         #{result[:demo].full_name}"
        puts "  #{result[:curr].year} average: #{result[:curr].batting_average}"
        puts "  #{result[:prev].year} average: #{result[:prev].batting_average}"
        puts "  diff:         #{result[:diff]}"
      end
    end

    desc 'Calculate the slugging percentage for given team and year'
    task :calc_slugging_pct_for_team do
      c = BBStats::Calculator.new(opts)
      result = c.calc_slugging_pct_for_team
      if result
        team_id = result[:team_id]
        year    = result[:year]
        spct    = result[:spct]
        puts format("Slugging percentage for team %s in %s was %s", team_id, year.to_s, spct)
        puts result[:team].inspect if opts[:verbose]
      end
    end

    desc 'Identify the triple-crown winner(s) for a given year'
    task :identify_triple_crown_winners do
      c = BBStats::Calculator.new(opts)
      mlb_results = c.identify_triple_crown_winners
      year = opts[:year]
      if mlb_results.empty?
        puts "no triple-crown winner(s) for #{year}"
      else
        mlb_results.each do | league_results |
        league = league_results[:league]
        full_name = league_results[:demo].full_name
        puts "triple-crown winner for #{year} in the #{league} is #{full_name}!"
        end
      end
    end

  end

  namespace :pitching do

    desc 'Calculate Earned Run Avarage (ERA)'
    task :calc_era do
      puts "TODO - future enhancement"
    end
  end

  desc 'Display the BBStats version info'
  task :version_info do
    puts "VERSION: #{BBStats::VERSION}"
    puts "DATE:    #{BBStats::DATE}"
    puts "AUTHOR:  #{BBStats::AUTHOR}"
    puts "EMAIL:   #{BBStats::EMAIL}"
  end

end
