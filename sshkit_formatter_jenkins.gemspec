# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sshkit_formatter_jenkins'

Gem::Specification.new do |spec|
  spec.name          = 'sshkit_formatter_jenkins'
  spec.version       = SSHKitFormatterJenkins::VERSION
  spec.authors       = ['Francho Joven', 'Rafa García']
  spec.email         = ['francho@spines.me', 'rafa@spines.me']

  spec.summary       = 'SSHKit formatter for our Jenkins'
  spec.homepage      = 'https://github.com/spinesme/sshkit_formatter_jenkins'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'sshkit', '>= 1.7.1'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
