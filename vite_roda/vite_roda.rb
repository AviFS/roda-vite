# frozen_string_literal: true

require "vite_ruby"
require_relative "vite_roda/version"
require_relative "vite_roda/tag_helpers"

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
