# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'red_cross/version'

Gem::Specification.new do |spec|
  spec.name          = 'red_cross'
  spec.version       = RedCross::VERSION
  spec.authors       = ['ronbarab']
  spec.email         = ['rbarabash@yotpo.com', 'vlad@yotpo.com', 'dmitri@yotpo.com']

  spec.summary       = 'Redcross gem transport events to an event collector'
  spec.description   = 'Redcross gem transport events to an event collector'
  spec.homepage      = 'https://github.com/YotpoLtd'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'analytics-ruby', '~> 2.2.2'
  spec.add_dependency 'typhoeus', '~> 0.6.5'
  spec.add_dependency 'resque', '>= 1.26'
  spec.add_dependency 'influxdb', '~> 0.6.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
end
