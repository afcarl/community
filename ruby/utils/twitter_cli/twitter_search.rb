require 'cgi'
require 'json'
require 'net/http'
require 'yaml'

=begin

Code Project

Using the Twitter api construct a command line twitter search utility.

We should be able to cd into the project folder and run:
$ twitter_search "some search phrase"

The output should be the total count of the search results with a list of the
first 25 results outputted to STDOUT. After each result, you should also output 
the twitter user for that result and a link to that user's profile.

You cannot use the rails framework or any twitter api gems.

You have 48 hours to push this project to your github account or you may zip 
the project up and email to us.

Do not create a gem out of this utility. It can just be a simple set of utility
scripts enclosed in a single folder (a gem like structure is ok, but not a full gem).

=end

class TwitterSearch

  attr_accessor :config

  def initialize
    @config = load_config
    if true
      puts "ARGV:      #{ARGV.inspect}"
      puts "config:    #{config.inspect}"
      puts "verbose?:  #{verbose?}"
      puts "search_term: #{search_term}"
    end

    if config
      case function
        when 'search'
          exec_search
        when 'user_name'
          exec_user_name_query
        when 'user_id'
          exec_user_id_query
        when 'followers'
          exec_followers_query
      end
    end
  end

  def load_config
    config_file = 'config/twitter_cli.yml'
    begin
      YAML::load(File.open(config_file))
    rescue Exception => e
      puts "Error loading #{config_file} - #{e.class.name} - #{e.message}"
      nil
    end
  end

  def function
    ARGV.each { | arg |
      return 'user_name' if arg == '--uname'
      return 'user_id'   if arg == '--uid'
      return 'followers' if arg == '--followers'
    }
    'search'
  end

  def search_term
    words, keyword_found = [], false
    ARGV.each { | arg |
      unless keyword_found
        if arg.start_with?('--')
          keyword_found = true
        else
          words << arg
        end
      end
    }
    words.join(' ').strip
  end

  def verbose?
    ARGV.each { | arg |
      return true if arg == '--v'
    }
    false
  end

  def search_url
    config['search_url'].strip
  end

  def user_lookup_url
    config['user_lookup_url'].strip
  end

  def user_id_lookup_url
    config['user_id_lookup_url'].strip
  end
  
  def followers_url
    config['followers_url'].strip
  end 

  def exec_search
    begin
      params = {'q' => search_term }
      raw = http_get(search_url, params)
      puts "raw response: #{raw}" if verbose?
      obj = JSON.parse(raw)
      puts to_pretty_json(obj)
    rescue Exception => e
      handle_exception(e)
    end
  end

  def exec_user_name_query
    begin
      params = {'screen_name' => search_term }
      raw = http_get(user_lookup_url, params)
      puts "raw response: #{raw}" if verbose?
      obj = JSON.parse(raw)
      puts to_pretty_json(obj)
    rescue Exception => e
      handle_exception(e)
    end
  end

  def exec_user_id_query
    begin
      params = {'user_id' => search_term }
      raw = http_get(user_id_lookup_url, params)
      puts "raw response: #{raw}" if verbose?
      obj = JSON.parse(raw)
      puts to_pretty_json(obj)
    rescue Exception => e
      handle_exception(e)
    end
  end

  def exec_followers_query
    # return if config.nil?
    # # curl -v 'http://api.twitter.com/1/users/lookup.format?user_id='
    # begin
    #   url = "#{@followers_url}#{cursor}&screen_name=#{URI.escape(screen_name)}"
    # rescue Exception => e
    #   handle_exception('followers_query', e)
    # end
    
    begin
      params = {'screen_name' => search_term }
      raw = http_get(followers_url, params)
      puts "raw response: #{raw}" if verbose?
      obj = JSON.parse(raw)
      puts to_pretty_json(obj)
    rescue Exception => e
      handle_exception(e)
    end 
  end

  private

  def http_get(url, params={})
    begin
      qstr = build_query_string(params)
      uri  = URI("#{url}#{qstr}")
      Net::HTTP.get(uri)
    rescue Exception => e
      handle_exception(e)
      nil
    end
  end

  def build_query_string(params={})
    sio = StringIO.new
    params.keys.sort.each_with_index { | name, idx |
      (idx == 0) ? c = '?' : c = '&'
      sio << "#{c}#{name}=#{CGI.escape(params[name])}"
    }
    sio.string
  end

  def handle_exception(e)
    puts "Exception => #{e.class.name} #{e.message}"
    puts e.backtrace
  end

  def to_json(obj)
    JSON.generate(obj)
  end

  def to_pretty_json(obj)
    JSON.pretty_generate(obj)
  end

  def log_pretty_json(obj)
    puts to_pretty_json(obj)
  end

  def parse_json(json_str)
    (json_str) ? JSON.parse(json_str) : nil
  end

  def plus_escape(desc)
    desc.tr(' ','+')
  end

  def write_file(out_name, content)
    out = File.new out_name, "w+"
    out.write content
    out.flush
    out.close
    puts "file written: #{out_name}"
  end

  def write_lines(out_name, lines)
    sio = StringIO.new
    lines.each { | line | sio << "#{line}\n" }
    write_file(out_name, sio.string)
  end

end

TwitterSearch.new
