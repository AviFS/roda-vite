# frozen_string_literal: true

require "vite_roda"

# If it is desired to instead extend the whole CLI, rather than just the install
# subcommand, write a cli.rb file instead of an installation.rb file. Vite Ruby
# first tries to load a framework specific cli.rb and then if that fails, loads
# installation.rb instead. Both Hanami and Padrino extensions just have an
# installation.rb file, but the Rails extension has a cli.rb file. To see the source
# code where this is loaded, see: https://github.com/ElMassimo/vite_ruby/blob/95c247a66d86f15ad9ce783acf92fef96646091b/vite_ruby/lib/vite_ruby/cli.rb#L20
# To see the reference installation.rb files, see reference/installation/vite_*.rb


# Internal: Extends the base installation script from Vite Ruby to work for a
# typical Roda app.
module ViteRoda::Installation
  RODA_TEMPLATES = Pathname.new(File.expand_path("../../../../templates", __dir__))

  # def call(**options)
  #   ensure_roda_plugin_added
  #   super
  # end

  def call(package_manager: nil, **)

    ensure_roda_plugin_added

    ENV["VITE_RUBY_PACKAGE_MANAGER"] ||= package_manager if package_manager

    $stdout.sync = true

    # Keep it minimal: Skip creating binstubs
    # say "Creating binstub"
    # ViteRuby.commands.install_binstubs

    # Create vite.config.ts and config/vite.json
    # say "Creating configuration files"
    create_configuration_files

    # Empty, skip creating app-specific sample files
    # say "Installing sample files"
    install_sample_files

    # Only return the command to run, don't run it
    js_command = install_js_dependencies

    # say "Adding files to .gitignore"
    # install_gitignore

    # say "\nVite ⚡️ Ruby successfully installed! 🎉"

    puts <<~POST_INSTALL_MESSAGE
    \e[2mIf you have your css in \e[36massets/css/app.css\e[0;2m, you'll want to add the following to your html:

    \e[2m   <head>\e[m
    \e[32m+    <%= vite(['app.css']) %>\e[m
    \e[2m   </head>\e[m

    \e[2mVite accepts an asset array including css, scss, javascript and typescript.

    To install \e[36mnode_modules/\e[0;2m, run:

    \e[0;1;36m  #{js_command}\e[m
    POST_INSTALL_MESSAGE
  end

  # Internal: Ensures the Vite plugin is loaded in app.rb, or [app_name].rb
  # This check is skipped if the -f or --force flag is passed
  def ensure_roda_plugin_added
    return if ARGV.any? { |flag| ['-f', '--force'].include? flag }

    unless line_with_prefix_exists? root.join('app.rb'), 'plugin :vite' ||
           line_with_prefix_exists? root.join("#{app_name}.rb"), 'plugin :vite'
       abort "Add plugin :vite to your Roda app (found in app.rb or #{app_name}.rb) before installing, or pass -f to force."
    end
  end

  # Internal: Get probable app_name for checking if plugin :vite has been loaded.
  # If this is wrong, the install subcommand can always be forced with -f.
  def app_name

    # Return the name of current working directory, for now. More complex logic may be added
    # here, including returning a list of probable app_names for use with #any? like:
    #   unless files.any? { |file| line_with_prefix_exists?(file, 'plugin :vite') }

    File.basename(Dir.pwd)
  end

  # Using String#lstrip and String#start_with? is supposedly faster than using Regex as:
  # File.readlines(file).any? { |line| line.match?(/^\s*plugin :vite/) } if File.exist?(file)
  def line_with_prefix_exists?(file, string)
    File.readlines(file).any? { |line| line.lstrip.start_with?(string) } if File.exist?(file)
  end

  # The two methods below are inteded for override, and overriden by Vite Hanami and Vite Padrino

  # Override: Setup a typical apps/web Roda app to use Vite.
  def setup_app_files

    # DO: Initialize config/vite.json with recommended config from templates/config/roda-vite.json

    # I kind of like the following from Vite Ruby but it requires defining a
    # local copy_template methods which has RODA_TEMPLATES as the template constant
    # copy_template "config/vite.json", to: config.config_path

    cp RODA_TEMPLATES.join("config/roda-vite.json"), config.config_path

    # Keep it minimal: Skip adding Rake tasks
    # append root.join("Rakefile"), <<~RAKE
    #   require 'vite_roda'
    #   ViteRuby.install_tasks
    # RAKE

  end

  # Override: Inject the vite client and sample script to the default HTML template.
  def install_sample_files
    # super

    # Keep it minimal: Skip creating a sample javascript file
    # cp RODA_TEMPLATES.join("entrypoints/application.js"), config.resolved_entrypoints_dir.join("application.js")

    # Keep it minimal: Skip adding vite_tags into layout file
    # inject_line_before root.join("views/layout.erb"), "</head>", <<-HTML
    # <%= vite(['app.css', 'app.js']) %>
    # HTML

  end

  private

  def install_js_packages(deps)
    # Keep it minimal: Skip installing npm modules, prompting developer to do it
    # Vite Ruby installs vite and vite-plugin-ruby for you, with the following line:
    # Vite Roda opts out of this behavior for now, instead outputting the instructions:
    # run_with_capture("#{config.package_manager} add -D #{deps}", stdin_data: "\n")

    # Escape the ^ in version specifier for ZSH interop converting:
    #   npm add -D vite@^6.2.6 vite-plugin-ruby@^5.1.1
    #   npm add -D vite@\^6.2.6 vite-plugin-ruby@\^5.1.1
    deps = deps.gsub('^', '\^')
    "#{config.package_manager} add -D #{deps}"
  end

  # Internal: Creates the Vite and vite-plugin-ruby configuration files.
  def create_configuration_files

    # This is because we're using a different vite.config.ts to restore defaults
    # If those settings are able to be put in config/vite.json instead, which is preferable,
    # then can go back to using the second one, which uses Vite Ruby's vite.config.ts

    cp RODA_TEMPLATES.join("vite.config.ts"), root.join("vite.config.ts")
    # copy_template "config/vite.config.ts", to: root.join("vite.config.ts")

    # Keep it minimal: Skip creating Procfile.dev and adding Vite task
    # append root.join("Procfile.dev"), "vite: bin/vite dev"

    setup_app_files
    ViteRuby.reload_with(config_path: config.config_path)
  end

end

puts "VITE RODA CLI" if ARGV.include?('--debug')

ViteRuby::CLI::Install.prepend(ViteRoda::Installation)
