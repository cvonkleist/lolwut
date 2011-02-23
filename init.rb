ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require File.expand_path("vendor/dependencies/lib/dependencies", File.dirname(__FILE__))
rescue LoadError
  require "dependencies"
end

require "monk/glue"
require "ohm"
require "haml"
require "sass"

class Main < Monk::Glue
  set :app_file, __FILE__
  secret =
    begin
      File.read('config/secret.txt')
    rescue Errno::ENOENT
      random_secret = rand(10**128).to_s(36)
      puts <<-EOS
        Creating a random secret key for sessions

        For your Sinatra app to safely use sessions, a secret key
        must be used to prevent users from tampering with their
        cookie data (which could lead to unauthorized access to your
        application if you store login information in the session).

        The file config/secret.txt has been created with the following
        secret:

        #{random_secret}
        
      EOS
      File.open('config/secret.txt', 'w') do |out|
        out.write random_secret
      end
      random_secret
    end
  use Rack::Session::Cookie, :secret => secret
end

# Connect to redis database.
Ohm.connect(monk_settings(:redis))

# Load all application files.
Dir[root_path("app/**/*.rb")].each do |file|
  require file
end

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
end

Main.run! if Main.run?
