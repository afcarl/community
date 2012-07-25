require 'cgi'
require 'json'
require 'net/http'
require 'yaml'

class TwitterSearch

  attr_accessor :config

  def initialize
    if ARGV.size == 0
      display_usage
    else
      @config = load_config
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
  end

  def display_usage
    puts ""
    puts "Error: Invalid command line arguments."
    puts ""
    puts "Examples:"
    puts "  ./twitter_search bradley wiggins      # text search for the cyclist bradley wiggins"
    puts "  ./twitter_search bradley wiggins --v  # same as above, but in verbose mode"
    puts "  ./twitter_search \"ham & eggs\"         # double-quote search terms with ampersands"
    puts "  ./twitter_search cjoakim --uname      # username search"
    puts "  ./twitter_search 17804871 --uid       # user ID search"
    puts "  ./twitter_search cjoakim --followers  # list the followers of the given username"
    puts ""
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
      params = {'q' => search_term, 'rpp' => '25' }
      raw = http_get(search_url, params)
      puts "raw response: #{raw}" if verbose?
      obj = JSON.parse(raw)
      log_pretty_json(obj) if verbose?
      report(obj)
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
      log_pretty_json(obj) if verbose?
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
      log_pretty_json(obj) if verbose?
    rescue Exception => e
      handle_exception(e)
    end
  end

  def exec_followers_query
    begin
      params = {'screen_name' => search_term }
      raw = http_get(followers_url, params)
      puts "raw response: #{raw}" if verbose?
      obj = JSON.parse(raw)
      log_pretty_json(obj) if verbose?
    rescue Exception => e
      handle_exception(e)
    end
  end

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

  def report(obj)
    results = obj['results']
    if results
      results.each_with_index { | result, idx |
        puts ""
        user = result['from_user']
        profile_url = "https://twitter.com/#{user}"
        log_pretty_json(result)
        puts "result number #{idx+1}, from #{user}, profile url #{profile_url}"
      }
    end
  end

end

TwitterSearch.new
