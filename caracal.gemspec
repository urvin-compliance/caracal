# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'caracal/version'

Gem::Specification.new do |spec|
  spec.name          = 'caracal'
  spec.version       = Caracal::VERSION
  spec.authors       = ['Urvin LLC', 'Dave Lauer']
  spec.email         = ['dave@plia.com']
  spec.summary       = %q{ Fast, professional Microsoft Word (docx) writer for Ruby. }
  spec.description   = %q{ Caracal is a pure Ruby Microsoft Word generation library that produces professional quality MSWord documents (docx) using a simple, HTML-style DSL. }
  spec.homepage      = 'https://github.com/urvin-compliance/caracal'
  spec.license       = 'MIT'

  spec.metadata      = {
    'source_code_uri' => 'https://github.com/urvin-compliance/caracal',
    'changelog_uri'   => 'https://github.com/urvin-compliance/caracal/blob/master/CHANGELOG.md',
    'bug_tracker_uri' => 'https://github.com/urvin-compliance/caracal/issues'
  }

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.1'

  spec.add_dependency 'nokogiri', '>= 1.16.2', '< 2.0'
  spec.add_dependency 'rubyzip',  '>= 1.1.6', '< 4.0'
  spec.add_dependency 'tilt',     '>= 1.4'

  spec.add_development_dependency 'bundler',  '>= 1.3'
  spec.add_development_dependency 'rake',     '>= 10.0'
  spec.add_development_dependency 'rspec',    '~> 3.0'
end
