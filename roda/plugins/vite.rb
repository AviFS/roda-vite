require_relative '../../vite_roda/vite_roda'

class Roda
  module RodaPlugins
    module Vite

      def self.load_dependencies(app, opts=OPTS)
        # app.plugin :render
        # app.plugin :assets
      end

      def self.configure(app, opts=OPTS)
      end

      STYLESHEET_MATCHER = /\.(css|scss|sass|less|styl)$/
      TYPESCRIPT_MATCHER = /\.(ts|tsx|mts|cts)$/

      module InstanceMethods

        include ViteRoda::TagHelpers

        # This is inspired by Laravel's @vite([]) Blade directive
        # Like its counterpart, it defaults to interpreting files as javascript
        #
        # It is meant to be used in views (e.g. layout.erb) to generate vite tags
        # Accepts a single asset path, or an array of paths:
        #
        #   <%= vite('resources/js/app.js') %>
        #   <%= vite(['resources/js/app.js', 'resources/css/app.css']) %>

        def vite(asset_paths)
          asset_paths = Array(asset_paths)
          vite_hmr_tag = vite_client

          asset_tags = asset_paths.map do |asset_path|
            if STYLESHEET_MATCHER.match?(asset_path)
              vite_stylesheet(asset_path)
            elsif TYPESCRIPT_MATCHER.match?(asset_path)
              vite_typescript(asset_path)
            else
              vite_javascript(asset_path)
            end
          end.join

          vite_hmr_tag ? "#{vite_hmr_tag}#{asset_tags}" : asset_tags
        end
      end
    end
    register_plugin(:vite, Vite)
  end
end
