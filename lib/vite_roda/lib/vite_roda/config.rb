# frozen_string_literal: true

# This is deliberately kept empty as it seems, for now, a better choice to explicitly set defaults
# in the config/vite.json file. This way the user can see what Vite Ruby defaults are being overriden
# and can expect the same behavior when taking their vite.json config to another framework supported
# by Vite Ruby. (The default vite.json added to a user's app on install lives in the templates/ directory.)
# However, this is kept here as a reminder that defaults can be configured here, if desired in the future.
# Neither Vite Hanami, nor Vite Padrino have this file or override defaults, however Vite Rails does,
# so for an example of what this can look like, see:
# https://github.com/ElMassimo/vite_ruby/blob/main/vite_rails/lib/vite_rails/config.rb

module ViteRoda::Config
  private

    # Override: Default values for a Roda application.
    def config_defaults

      # As of 5/18/25, the Vite Rails plugin checks Rails' asset host, assigning it to a
      # variable which could be done by checking Roda's assets plugin, and sets:
      #
      #   super(
      #     asset_host: asset_host,
      #     mode: env
      #     root: root || Dir.pwd,
      #   )

      super

    end
  end

  ViteRuby::Config.singleton_class.prepend(ViteRoda::Config)
