# frozen_string_literal: true

require "vite_roda"

# Internal: Extends the base installation script from Vite Ruby to work for a
# typical Roda app.
module ViteRoda::Installation
  RODA_TEMPLATES = Pathname.new(File.expand_path("../../templates", __dir__))

  # Override: Setup a typical apps/web Roda app to use Vite.
  def setup_app_files

    # DO: Initialize config/vite.json with recommended config from templates/config/roda-vite.json

    cp RODA_TEMPLATES.join("config/roda-vite.json"), config.config_path

    # Keep it minimal: Skip adding Rake tasks
    # append root.join("Rakefile"), <<~RAKE
    #   require 'vite_roda'
    #   ViteRuby.install_tasks
    # RAKE

  end

  # Override: Inject the vite client and sample script to the default HTML template.
  def install_sample_files
    super

    # Keep it minimal: Skip adding vite_tags into layout file
    # inject_line_before root.join("views/layout.erb"), "</head>", <<-HTML
    # <%= vite(['app.css', 'app.js']) %>
    # HTML

  end
end

puts "VITE RODA CLI"

ViteRuby::CLI::Install.prepend(ViteRoda::Installation)
