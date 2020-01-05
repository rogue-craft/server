if ENV['GENERATE_COVERAGE']
  require 'simplecov'
  SimpleCov.start

  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require_relative "../../lib/rogue-craft-server/container_loader"

require "minitest/autorun"
require 'mocha/minitest'

Dependency.container.config.resolver = -> (_, _) { nil }
