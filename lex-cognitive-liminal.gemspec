# frozen_string_literal: true

require_relative 'lib/legion/extensions/cognitive_liminal/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-cognitive-liminal'
  spec.version       = Legion::Extensions::CognitiveLiminal::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']
  spec.summary       = 'Liminal threshold states between cognitive modes for LegionIO agents'
  spec.description   = 'Models liminality — the creative in-between states during cognitive ' \
                       'mode transitions with ambiguity, dissolution, and crystallization'
  spec.homepage      = 'https://github.com/LegionIO/lex-cognitive-liminal'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata = {
    'homepage_uri'          => spec.homepage,
    'source_code_uri'       => spec.homepage,
    'documentation_uri'     => "#{spec.homepage}/blob/origin/README.md",
    'changelog_uri'         => "#{spec.homepage}/blob/origin/CHANGELOG.md",
    'bug_tracker_uri'       => "#{spec.homepage}/issues",
    'rubygems_mfa_required' => 'true'
  }

  spec.files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }
  spec.require_paths = ['lib']
end
