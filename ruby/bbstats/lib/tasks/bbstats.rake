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
    hash[:team]    = command_line_arg('team', nil)
    hash[:year]    = command_line_arg('year', nil)
    hash[:verbose] = command_line_arg('verbose', '').downcase == 'true'
    hash
  end

  namespace :batting do

    desc 'Calculate the most improved batting average for a given year'
    task :calc_most_improved_avg do
      c = BBStats::Calculator.new(opts)
      c.calc_most_improved_avg
    end

    desc 'Calculate the slugging percentage for given team and year'
    task :calc_slugging_pct_for_team do
      c = BBStats::Calculator.new(opts)
      c.calc_slugging_pct_for_team
    end

    desc 'Identify the triple-crown winner for a given year'
    task :identify_triple_crown_winner do
      c = BBStats::Calculator.new(opts)
      c.identify_triple_crown_winner
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
