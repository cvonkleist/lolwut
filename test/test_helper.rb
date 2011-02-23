ENV['RACK_ENV'] = 'test'

require File.expand_path(File.join(File.dirname(__FILE__), "..", "init"))

require "rack/test"
require 'webrat'
require 'rspec'

begin
  puts "Connected to Redis #{Ohm.redis.info[:redis_version]} on #{monk_settings(:redis)[:host]}:#{monk_settings(:redis)[:port]}, database #{monk_settings(:redis)[:db]}."
rescue Errno::ECONNREFUSED
  puts <<-EOS

    Cannot connect to Redis.

    Make sure Redis is running on #{monk_settings(:redis)[:host]}:#{monk_settings(:redis)[:port]}.
    This testing suite connects to the database #{monk_settings(:redis)[:db]}.

    To start the server:
      env RACK_ENV=test monk redis start

    To stop the server:
      env RACK_ENV=test monk redis stop

  EOS
  exit 1
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Webrat::Methods
  conf.include Webrat::Matchers # require for "should contain(...)"
  def app
    Main
  end

  def body
    last_response.body
  end

  def flush_db
    Ohm.flush if monk_settings(:redis)[:db] == 15 # paranoia to prevent wiping out a prod database somehow
  end

  conf.before(:each) do
    flush_db
  end
end
