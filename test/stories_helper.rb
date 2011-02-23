require "test_helper"

require "webrat"
require "rack/test"

Webrat.configure do |config|
  config.mode = :rack
end
