require_relative 'lib/version'

Gem::Specification.new do |s|
  s.name        = 'roda-vite'
  s.version     = RodaVite::VERSION
  s.authors     = ['Avi Sternlieb']
  s.email       = ['avifsternlieb@gmail.com']

  s.summary     = 'A Roda plugin for Vite, leveraging Vite Ruby.'
  s.homepage    = 'https://github.com/avifs/roda-vite'
  s.license     = 'MIT'

  # s.metadata = {
  #   'source_code_uri' =>
  #   'changelog_uri' =>
  #   'documentation_uri' =>
  #   'mailing_list_uri' =>
  #   'bug_tracker_uri' =>
  # }

  s.required_ruby_version = '>= 2.5'

  s.add_dependency 'vite_ruby-roda', '~> 3.0'

  s.files = Dir['{lib,templates}/**/*'] + %w[README.md CHANGELOG.md LICENSE]

  s.bindir = ['bin']
  s.executables = ['roda-vite']
end
