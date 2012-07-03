=begin

Rake tasks for comparing the versions of the gems in your Gemfile
to the current list of remote gems, so that you can easily determine
if your Gemfile is up-to-date.

Copyright (C) 2012 Chris Joakim, joakimsoftware.com.

Usage:
------
1.  Simply drop this file into directory lib/tasks/ of your Rails app.

2.  You first have to run "rake gemcheck:fetch" to fetch the list of
    remote gems to file 'tmp/remote_gems.txt'.  Rerun this task
    as-necessary to get the latest info.

3.  Run rake gemcheck:compare" to compare the gem versions in your
    Gemfile to the (current) list of remote gems.  It will produce
    a report like the following:

    Gem Name                 Gemfile      Remote       Comment
    rails                    3.1.3        3.2.6        not current
    thin                     1.3.1        1.4.1        not current
    pg                       0.12.2       0.14.0       not current
    redis                    2.2.2        3.0.1        not current
    bunny                    0.7.8        0.8.0        not current
    newrelic_rpm             latest       3.4.0.1
    sass-rails               3.1.5        3.2.5        not current
    coffee-rails             3.1.1        3.2.2        not current
    uglifier                 1.0.3        1.2.6        not current
    turn                     0.8.2        0.9.6        not current
    rspec                    2.10.0       2.10.0       current
    rack-test                0.6.1        0.6.1        current
    capybara                 1.1.2        1.1.2        current

=end

namespace :gemcheck do

  desc "Fetch the list of remote gems"
  task :fetch => :environment do
    Gemcheck.new.fetch
  end

  desc "Compare the Gemfile to remote gems list"
  task :compare => :environment do
    Gemcheck.new.compare
  end

end

class Gemcheck

  attr_reader :remote_gems_file, :remote_gems, :gemfile_gems

  def initialize
    @remote_gems_file = 'tmp/remote_gems.txt'
    @remote_gems, @gemfile_gems = {}, []
  end

  def fetch
    puts "fetching remote gems list to file #{remote_gems_file}"
    `gem list --remote > #{remote_gems_file}`
  end

  def compare
    if File.exist?('Gemfile')
      if File.exist?(remote_gems_file)
        read_remote_gems_file
        read_gemfile
        compare_lists
      else
        puts "ERROR: remote gems file #{remote_gems_file} does not exist!"
        puts "       run 'rake gemcheck:fetch' to create this file."
      end
    else
      puts "ERROR: Gemfile does not exist!"
    end
  end

  def read_remote_gems_file
    lines = IO.readlines(remote_gems_file)
    puts "#{lines.size} lines in remote gems list"
    lines.each { | line |
      stripped = line.strip
      tokens = stripped.split
      if tokens.size > 0
        idx = stripped.index(' ')
        if idx
          gem_name = stripped.slice(0,idx).strip
          version_info = stripped.slice(idx,999).strip
          version_info.tr!('()','').strip
          version_tokens = version_info.split(',')
          version = version_tokens[0]
          vtokens = version.split
          version = vtokens[0]
          if gem_name && version
            remote_gems[gem_name] = version
          end
        end
      end
    }
    puts "#{remote_gems.size} remote gems parsed"
  end

  def read_gemfile
    lines = IO.readlines('Gemfile')
    puts "Gemfile is present in #{Dir.pwd}, #{lines.size} lines"
    lines.each { | line |
      stripped = line.strip
      stripped.tr!('",\'','')
      tokens = stripped.split
      if tokens[0] == 'gem' && tokens.size > 2
        gem_name, gem_vers = tokens[1], 'latest'
        comment_found = false
        tokens.each { | t |
          if t.index('#') == 0
            comment_found = true
          end
          unless comment_found
            gem_vers = t if version?(t)
          end
        }
        if gem_name && gem_vers
          gemfile_gems << [gem_name, gem_vers]
        end
      end
    }
  end

  def compare_lists
    puts ""
    puts "Gem Name                 Gemfile      Remote       Comment"
    gemfile_gems.each { | array |
      gem_name, gem_vers = array[0], array[1]
      curr_vers = remote_gems[gem_name]
      comment = ''
      unless gem_vers == 'latest'
        comment = (gem_vers == curr_vers) ? 'current' : 'not current'
      end
      puts sprintf("%-24s %-12s %-12s %s", gem_name, gem_vers, curr_vers, comment)
    }
    puts ""
  end

  def fetch_gem_list?
    fetch = true
    ARGV.each { | arg | fetch = false if arg == 'nofetch' }
    fetch
  end

  def version?(s)
    return false if s.nil?
    digits = s.tr('.','')
    digits.to_i > 0
  end

end
