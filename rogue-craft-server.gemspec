lib = File.expand_path("../lib", __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rogue-craft-server"
  spec.version       = "0.1.0"
  spec.authors       = ["Isty001"]
  spec.email         = ["isty001@gmail.com"]

  spec.summary       = %q{: Write a short summary, because RubyGems requires one.}
  spec.description   = %q{: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = ": Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir['README.md', 'VERSION', 'Gemfile', 'Rakefile', '{bin,lib,config,resources}/**/*']

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dry-container", "~> 0.7.0"
  spec.add_runtime_dependency "dry-auto_inject", "~> 0.6.0"
  spec.add_runtime_dependency "dry-events", "~> 0.1.0"

  spec.add_runtime_dependency "eventmachine", "~> 1.2"
  spec.add_runtime_dependency "dotenv", "~> 2.6"

  spec.add_runtime_dependency "ohm", "~> 3.1.1"
  spec.add_runtime_dependency "ohm-contrib", "~> 3"

  spec.add_runtime_dependency "bcrypt", "~> 3"

  spec.add_runtime_dependency "mail", "~> 2.7"

  spec.add_development_dependency "resque", "~> 2.0"

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "mocha", "~> 1.8"
end
