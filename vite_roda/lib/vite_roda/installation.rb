# frozen_string_literal: true

require "vite_roda"

# Internal: Extends the base installation script from Vite Ruby to work for a
# typical Roda app.
module ViteRoda::Installation
  RODA_TEMPLATES = Pathname.new(File.expand_path("../../templates", __dir__))

  # Override: Setup a typical apps/web Roda app to use Vite.
  def setup_app_files
    cp RODA_TEMPLATES.join("config/roda-vite.json"), config.config_path
    append root.join("Rakefile"), <<~RAKE
      require 'vite_roda'
      ViteRuby.install_tasks
    RAKE
  end

  # Override: Inject the vite client and sample script to the default HTML template.
  def install_sample_files
    super
    inject_line_before root.join("views/layout.erb"), "</head>", <<-HTML
    <%= vite(['app.css', 'app.js']) %>
    HTML
  end
end

puts "VITE RODA CLI"

ViteRuby::CLI::Install.prepend(ViteRoda::Installation)
