# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'machine_tag/version'

Gem::Specification.new do |spec|
  spec.name          = "machine_tag"
  spec.version       = MachineTag::VERSION
  spec.authors       = ["Douglas Thrift"]
  spec.email         = ["douglas@douglasthrift.net"]
  spec.description   = %q{A Ruby library for using machine tags like those used on Flickr and RightScale}
  spec.summary       = %q{Library for using machine tags}
  spec.homepage      = "https://github.com/douglaswth/machine_tag"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version  = '>= 1.9.3'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "redcarpet"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "yard"
end
