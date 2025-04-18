# frozen_string_literal: true

require "vite_ruby"
require_relative "vite_roda/version"
require_relative "vite_roda/tag_helpers"

# ViteRuby::COMPANION_LIBRARIES is a hash containing the companion
# libraries for Vite Ruby, and their target framework, defined at:
# https://github.com/ElMassimo/vite_ruby/blob/95c247a66d86f15ad9ce783acf92fef96646091b/vite_ruby/lib/vite_ruby.rb#L23

# It's required to autoload the cli extensions (e.g. the one at vite_roda/installation.rb)
# in ViteRuby::CLI::require_framework_libraries at:
# https://github.com/ElMassimo/vite_ruby/blob/95c247a66d86f15ad9ce783acf92fef96646091b/vite_ruby/lib/vite_ruby/cli.rb#L20

# And it is called in the bin/vite executable installed by Vite Ruby at line 10:
# https://github.com/ElMassimo/vite_ruby/blob/95c247a66d86f15ad9ce783acf92fef96646091b/vite_ruby/exe/vite#L10


# I believe this might need to match the name of the gem
ViteRuby::COMPANION_LIBRARIES['vite_roda'] = 'roda'
# ViteRuby::COMPANION_LIBRARIES['roda-vite'] = 'roda'

module ViteRoda

  # # Internal: Called when the Rack app is available.
  # def self.registered(app)
  #   if RACK_ENV != "production" && ViteRuby.run_proxy?
  #     app.use(ViteRuby::DevServerProxy, ssl_verify_none: true)
  #   end
  #   ViteRuby.instance.logger = app.logger
  #   included(app)
  # end

  # # Internal: Called when the module is registered in the Padrino app.
  # def self.included(base)
  #   base.send :include, ViteRoda::TagHelpers
  # end

end
