# frozen_string_literal: true

# This is a Roda integration for Vite Ruby
#
# The Git repo for that project is hosted at: https://github.com/ElMassimo/vite_ruby
# And the documentation site is hosted at: https://vite-ruby.netlify.app/
#
# It is copied from the three other Vite Ruby extensions for Rails/Hanami/Padrino, as well
# as the legacy extensions, as faithfully as possible with minimal changes to make it work

# Public: Allows to render HTML tags for scripts and styles processed by Vite.
module ViteRoda::TagHelpers
  # Public: Renders a script tag for vite/client to enable HMR in development.
  def vite_client
    return unless src = vite_manifest.vite_client_src

    %Q[<script type="module" src="#{src}"></script>]
  end

  # Public: Renders a script tag to enable HMR with React Refresh.
  def vite_react_refresh
    vite_manifest.react_refresh_preamble
  end

  # Public: Resolves the path for the specified Vite asset.
  #
  # Example:
  #   <%= vite_asset_path 'calendar.css' %> # => "/vite/assets/calendar-1016838bab065ae1e122.css"
  def vite_asset_path(name, **options)
    asset_path vite_manifest.path_for(name, **options)
  end

  # Public: Renders a <script> tag for the specified Vite entrypoints.
  def vite_javascript(*names,
    type: "module",
    asset_type: :javascript,
    skip_preload_tags: false,
    skip_style_tags: false,
    crossorigin: "anonymous",
    **options)
    entries = vite_manifest.resolve_entries(*names, type: asset_type)
    tags = javascript(*entries.fetch(:scripts), crossorigin: crossorigin, type: type, **options)
    tags << vite_modulepreload(*entries.fetch(:imports), crossorigin: crossorigin) unless skip_preload_tags
    tags << stylesheet(*entries.fetch(:stylesheets)) unless skip_style_tags
    tags
  end

  # Public: Renders a <script> tag for the specified Vite entrypoints.
  def vite_typescript(*names, **options)
    vite_javascript(*names, asset_type: :typescript, **options)
  end

  # Public: Renders a <link> tag for the specified Vite entrypoints.
  def vite_stylesheet(*names, **options)
    style_paths = names.map { |name| vite_asset_path(name, type: :stylesheet) }
    stylesheet(*style_paths, **options)
  end

private

  # This may eventually delegate to Roda's assets plugin
  def asset_path(path)
    # "/build/#{path}"  # <- pubic/build/
    path
  end

  # Internal: Returns the current manifest loaded by Vite Ruby.
  def vite_manifest
    ViteRuby.instance.manifest
  end

  # Internal: Renders a modulepreload link tag.
  def vite_modulepreload(*sources, crossorigin:)
    puts sources.size
    sources.map do |source|
      href = asset_path(source)

      # Enables preloading, early hints are implemented in Puma and Falcon
      # With puma, run with puma --early-hints
      if early_hints = env['rack.early_hints']
        puts 'early hints'
        early_hints.call(
          'Link' => %[<#{href}>; rel=modulepreload; as=script; crossorigin=#{crossorigin}]
        )
      else
        puts 'no early hints'
      end

      puts href
      modulepreload(href, crossorigin: crossorigin)
    end.join
  end

  # Implement an interface for rendering javascript and stylesheet tags. Approximates
  # the interfaces given by Rails/Hanami/Padrino and used by the other Vite extensions
  def javascript(*sources, **options)
    attributes = attributes(options)
    sources.map do |source|
      %Q[<script src="#{source}"#{attributes}></script>]
    end.join
  end

  def stylesheet(*sources, **options)
    attributes = attributes(options)
    sources.map do |source|
      %Q[<link rel="stylesheet" href="#{source}"#{attributes}>]
    end.join
  end

  def modulepreload(*sources, **options)
    attributes = attributes(options)
    sources.map do |source|
      %Q[<link rel="modulepreload" href="#{source}" as="script"#{attributes}>]
    end.join
  end

  def attributes(hash)
    # Boolean attribute must be handled with care. If an attribute is present,
    # it is interpreted as true, so checked="false" is still true. When true,
    # render just the attribute with no value, when false, omit the attribute entirely
    options = hash.filter_map { |key, val| val == true ? key : %Q[#{key}="#{val}"] if val }.join(' ')
    options = ' ' + options unless options.empty?
    options
  end
end
