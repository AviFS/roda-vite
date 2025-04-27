def gem_installed?(name)
  Gem::Specification.find_by_name(name)
  true
rescue Gem::LoadError
  false
end

begin
  require 'vite_ruby-roda'
rescue LoadError => e
  raise unless e.path == 'vite_ruby-roda'
  if gem_installed?('vite_ruby')
    raise "Missing dependency: vite_ruby-roda is required by roda-vite. Please add it to your Gemfile.\n" +
          'Found vite_ruby, however roda-vite requires vite_ruby-roda. If vite_ruby is in your Gemfile, you may replace it.'
  else
    raise 'Missing dependency: vite_ruby-roda is required by roda-vite. Please add it to your Gemfile.'
  end
end

$LOAD_PATH.unshift(File.expand_path('vite_roda/lib', __dir__))
