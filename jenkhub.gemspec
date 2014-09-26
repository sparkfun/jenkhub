# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jenkhub/version'

Gem::Specification.new do |spec|
  spec.name          = 'jenkhub'
  spec.version       = Jenkhub::VERSION
  spec.authors       = ['Tyler Cipriani']
  spec.email         = ['tyler.cipriani@sparkfun.com']
  spec.summary       = %q(Jenkins github watcher)
  spec.description   = %q(SparkFun Jenkins GitHub Command line app)
  spec.homepage      = ''
  spec.license       = 'GPLv2'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
