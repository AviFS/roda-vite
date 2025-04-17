require_relative 'vite_roda/vite_roda'

class TagBuilder

  include ViteRoda::TagHelpers

  def initialize(skip_preload_tags: false)
    @preload = []
    @skip_preload_tags = skip_preload_tags
  end

  def vite_javascript(*names,
    type: "module",
    asset_type: :javascript,
    skip_style_tags: false,
    crossorigin: "anonymous",
    **options)

    entries = vite_manifest.resolve_entries(*names, type: asset_type)
    add_javascript(*entries.fetch(:scripts), crossorigin: crossorigin, type: type, **options)
    add_javascript(*entries.fetch(:imports), crossorigin: crossorigin)
    add_stylesheet(*entries.fetch(:stylesheets)) unless skip_style_tags
  end

  def vite_typescript(*names, **options)
    vite_javascript(*names, asset_type: :typescript, **options)
  end

  def add_stylesheet(src)
    @preload.push()
  end

  def add_javascript(src)
    @preload.push(src)
  end

  def add_typescript(src)
  end

  # Return tags as string, but also sends 103 Early Hints response
  # with 'Link' header for preloading, so it has a side-effect
  def tags!
  end

  private

  def dev_server_running?
    vite_manifest.dev_server_running?
  end

end
