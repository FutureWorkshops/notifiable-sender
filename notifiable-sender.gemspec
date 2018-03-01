# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'notifiable/sender/version'

Gem::Specification.new do |spec|
  spec.name          = "notifiable-sender"
  spec.version       = Notifiable::VERSION
  spec.authors       = ["Matt Brooke-Smith"]
  spec.email         = ["matt@futureworkshops.com"]

  spec.summary       = %q{Connect to Notifiable's notifications API.}
  spec.homepage      = "https://github.com/FutureWorkshops/notifiable-sender"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client'
  spec.add_dependency 'api-auth', '~> 2.1'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.3.1"
  spec.add_development_dependency "byebug"
end
