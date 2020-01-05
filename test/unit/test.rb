if 1 || ENV['GENERATE_COVERAGE']
  require 'coveralls'

  Coveralls.wear!
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require_relative "../../lib/rogue-craft-server/container_loader"

require 'minitest/autorun'
require 'mocha/minitest'

Dependency.container.config.resolver = -> (_, _) { nil }
