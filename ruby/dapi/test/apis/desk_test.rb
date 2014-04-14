require "test_helper"

# rake test:file f=test/apis/desk_test.rb

describe 'Desk.com API' do

  describe 'initialization and environment variables' do

    it "requires certain environment variables to be present" do
      api = Desk.new
      api.environent_variables_present?.must_equal(true)
      api.consumer.nil?.must_equal(false)
      api.access_token.nil?.must_equal(false)
      api.exception?.must_equal(false)

      ENV['DESK_TOKEN_SECRET'] = nil
      api = Desk.new
      api.environent_variables_present?.must_equal(false)
      api.consumer.nil?.must_equal(true)
      api.access_token.nil?.must_equal(true)
      api.exception?.must_equal(true)
    end
  end

  describe '/cases' do

    it "must handle malformed JSON responses in method 'get_cases'" do
      api = Desk.new
      test_cases = []
      test_cases << '{}'
      test_cases << '{"total_entries":0}'
      test_cases << '{"_embedded":{"entries":666}}'
      test_cases << '{"_embedded":{"entries":"what?"}}'
      test_cases << '{"_embedded":{"entries":{}}}'
      test_cases << '{"_embedded":{ ......  zzzzz'

      test_cases.each do | body |
        api.test_init(body)
        api.get_cases.must_equal(nil)
      end
    end

    it "must handle properly formed JSON responses in method 'get_cases'" do
      api = Desk.new
      api.test_init(IO.read('test/fixtures/cases.json'))
      json = api.get_cases
      json['_embedded']['entries'].first['id'].must_equal(1)
      json['_embedded']['entries'].first['subject'].must_equal('Welcome to Desk.com')
      json['_embedded']['entries'].last['id'].must_equal(2)
      json['_embedded']['entries'].last['subject'].must_equal('Welcome to Desk.com')
    end
  end

  describe '/labels' do

    it "must handle malformed JSON responses in method 'get_labels'" do
      api = Desk.new
      test_cases = []
      test_cases << '{}'
      test_cases << '{"total_entries":0}'
      test_cases << '{"_embedded":{"entries":666}}'
      test_cases << '{"_embedded":{"entries":"what?"}}'
      test_cases << '{"_embedded":{"entries":{}}}'
      test_cases << '{"_embedded":{ ......  zzzzz'

      test_cases.each do | body |
        api.test_init(body)
        api.get_labels.must_equal(nil)
      end
    end

    it "must handle properly formed JSON responses in method 'get_cases'" do
      api = Desk.new
      api.test_init(IO.read('test/fixtures/labels.json'))
      json = api.get_cases
      json['_embedded']['entries'].first['id'].must_equal(1730082)
      json['_embedded']['entries'].first['name'].must_equal('Abandoned Chats')
      json['_embedded']['entries'].last['id'].must_equal(1730076)
      json['_embedded']['entries'].last['name'].must_equal('Sample Macros')
    end

  end

end

