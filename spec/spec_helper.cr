require "spectator"
require "../src/glove"

Spectator.configure do |config|
  config.fail_blank # Fail on no tests.
  config.profile    # Display slowest tests.
end

include Cadmium
