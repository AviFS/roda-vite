# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('./lib', __dir__)
require 'vite_roda/version'

Gem::Specification.new do |s|
  s.name = 'vite_roda'
  s.version = ViteRoda::VERSION
  s.authors = ['Avi Sternlieb']
  # s.email = ['maximomussini@gmail.com']
  s.summary = 'Vite Roda'
  s.homepage = 'https://github.com/avifs/roda-vite'
  s.license = 'MIT'

  # s.metadata = {
  #   'source_code_uri' => 'https://github.com/ElMassimo/vite_ruby/tree/vite_hanami@#{ViteHanami::VERSION}/vite_hanami',
  #   'changelog_uri' => 'https://github.com/ElMassimo/vite_ruby/blob/vite_hanami@#{ViteHanami::VERSION}/vite_hanami/CHANGELOG.md',
  #   'rubygems_mfa_required' => 'true',
  # }

  s.required_ruby_version = Gem::Requirement.new('>= 2.5')

  s.add_dependency 'vite_ruby', '~> 3.0'

  s.files = Dir.glob('{lib,templates}/**/*') # + %w[README.md CHANGELOG.md LICENSE.txt]
  # s.files = Dir.glob('{.,vite_roda/templates}/**/*') # + %w[README.md CHANGELOG.md LICENSE.txt]
end
