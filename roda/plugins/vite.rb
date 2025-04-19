require_relative '../../vite_roda/lib/vite_roda'
require_relative '../../tag_builder'

class Roda
  module RodaPlugins
    module Vite

      def self.load_dependencies(app, opts=OPTS)
        # app.plugin :render
        # app.plugin :assets
      end

      def self.configure(app, opts=OPTS)
        # Can be skipped with config skipProxy: true or env VITE_RUBY_SKIP_PROXY="true"
        proxy_dev_server(app)
      end

      # Vite Ruby proxies the Vite dev server localhost:3036 at localhost:9292. I'm not sure
      # why it does this, rather than just linking to localhost:3036, but it does, so this
      # is added for backward-compatibility and to minimally change Vite Ruby's behavior
      def self.proxy_dev_server(app)
        app.use(ViteRuby::DevServerProxy, ssl_verify_none: true) if ViteRuby.run_proxy?
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

=begin
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
=end

        def vite(asset_paths)
          asset_paths = Array(asset_paths)
          tag_builder = TagBuilder.new(env)

          asset_paths.each do |asset_path|
            if STYLESHEET_MATCHER.match?(asset_path)
              tag_builder.add_stylesheet(asset_path)
            elsif TYPESCRIPT_MATCHER.match?(asset_path)
              tag_builder.add_typescript(asset_path)
            else
              tag_builder.add_javascript(asset_path)
            end
          end

          tag_builder.tags!
        end

      end
    end
    register_plugin(:vite, Vite)
  end
end
