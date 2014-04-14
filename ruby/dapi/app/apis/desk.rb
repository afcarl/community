
# The purpose of this class is to invoke the Desk.com API.

class Desk

  attr_reader :consumer, :access_token, :body, :json, :exception

  @@env_vars = %w( DESK_CONSUMER_KEY DESK_CONSUMER_SECRET DESK_TOKEN DESK_TOKEN_SECRET )

  def initialize
    begin
      @body, @json, @exception = nil, nil, nil
      if environent_variables_present?
        @consumer  = OAuth::Consumer.new(
          ENV['DESK_CONSUMER_KEY'],
          ENV['DESK_CONSUMER_SECRET'],
          :site   => "https://joakimsoftwarellc.desk.com",
          :scheme => :header
        )
        @access_token = OAuth::AccessToken.from_hash(
          consumer,
          :oauth_token        => ENV['DESK_TOKEN'],
          :oauth_token_secret => ENV['DESK_TOKEN_SECRET']
        )
      else
        raise 'Required environment varaible(s) are not present'
      end
    rescue Exception => e
      @exception = e
      Rails.logger.error("Exception in Desk API constructor - #{e.class.name} - #{e.message}")
    end
  end

  def environent_variables_present?
    @@env_vars.each { | var | return false if ENV[var].nil? }
    true
  end

  def exception?
    exception != nil
  end

  def api_base_url
    'https://joakimsoftwarellc.desk.com/api/v2'
  end

  def cases_url
    "#{api_base_url}/cases"
  end

  def labels_url
    "#{api_base_url}/labels"
  end

  def get_cases
    @body = get(cases_url) if body.nil?
    (body.nil?) ? nil : parse_cases_response
  end

  def get_labels
    @body = get(labels_url) if body.nil?
    (body.nil?) ? nil : parse_labels_response
  end

  def create_label(data={})
    begin
      result = access_token.post(
        labels_url,
        data.to_json,
        {'Accept'=>'application/json', 'Content-Type' => 'application/json'}
      )
      JSON.parse(result.body)
    rescue Exception => e
      @exception = e
      Rails.logger.error("Exception in Desk API get - #{url} - #{e.class.name} - #{e.message}")
      nil
    end
  end

  def assign_label(label_id, case_id)

  end

  # This method is used for testing purposes only.
  # It is used to "inject" simulated HTTP response bodies.
  def test_init(b)
    @body, @json, @exception = b, nil, nil
  end

  private

  def get(url)
    begin
      response = access_token.get(url)
      # if true
      #   Rails.logger.debug("---\nresponse.body for url: #{url}")
      #   Rails.logger.debug(response.body)
      #   Rails.logger.debug("-")
      #   Rails.logger.debug(JSON.pretty_generate(JSON.parse(response.body)))
      #   Rails.logger.debug("---")
      # end
      if response && response.body
        response.body
      else
        nil
      end
    rescue Exception => e
      @exception = e
      Rails.logger.error("Exception in Desk API get - #{url} - #{e.class.name} - #{e.message}")
      nil
    end
  end

  def parse_cases_response
    begin
      return nil if body.nil?
      @json = JSON.parse(body)
      return nil if json.nil?
      return nil if json.class != Hash
      return nil unless json['_embedded']
      return nil unless json['_embedded']['entries']
      return nil unless json['_embedded']['entries'].class == Array
      first_entry = json['_embedded']['entries'].first
      if first_entry
        return nil unless first_entry['id'].to_s.to_i > 0
      end
      json
    rescue Exception => e
      @exception = e
      Rails.logger.error("Exception valid_cases_response - #{e.class.name} - #{e.message}")
      nil
    end
  end

  def parse_labels_response
    begin
      return nil if body.nil?
      @json = JSON.parse(body)
      return nil if json.nil?
      return nil if json.class != Hash
      return nil unless json['_embedded']
      return nil unless json['_embedded']['entries']
      return nil unless json['_embedded']['entries'].class == Array
      first_entry = json['_embedded']['entries'].first
      if first_entry
        return nil unless first_entry['id'].to_s.to_i > 0
      end
      json
    rescue Exception => e
      @exception = e
      Rails.logger.error("Exception valid_cases_response - #{e.class.name} - #{e.message}")
      nil
    end
  end

end
