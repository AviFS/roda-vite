require_relative 'vite_roda/lib/vite_roda'

class TagBuilder

  include ViteRoda::TagHelpers

  Tag = Data.define(:type, :src)

  # These are just to be backward compatible with Vite Ruby
  attr_accessor :skip_preload_tags, :skip_style_tags, :crossorigin

  def initialize(env, skip_preload_tags: false, skip_style_tags: false, crossorigin: "anonymous")
    @env = env
    @tags = []

    @skip_preload_tags = skip_preload_tags
    @skip_style_tags = skip_style_tags
    @crossorigin = crossorigin
  end

  def add_stylesheet(src)
    src = resolve(src, type: :stylesheet)
    add_resolved_stylesheet(src)
  end

  def add_javascript(src)
    add_script(src, type: :javascript)
  end

  def add_typescript(src)
    add_script(src, type: :typescript)
  end

  # This method may have a side-effect of sending a
  # 103 Early Hints status and Link header for preloading
  def tags!
    if dev_server_running?
      vite_hmr_tag + load_tags
    else
      send_early_hints
      preload_tags + load_tags
    end
  end

  private

  def dev_server_running?
    vite_manifest.dev_server_running?
  end

  def vite_hmr_tag
    vite_client
  end

  def add_script(src, type:)
    entries = vite_manifest.resolve_entries(src, type:)
    entries.fetch(:scripts).each      { |entry| add_resolved_javascript(entry) }
    entries.fetch(:imports).each      { |entry| add_resolved_javascript(entry) }  unless @skip_preload_tags
    entries.fetch(:stylesheets).each  { |entry| add_resolved_stylesheet(entry) }  unless @skip_style_tags
  end

  def add_resolved_javascript(src)
    @tags.push Tag[:js, src]
  end

  def add_resolved_stylesheet(src)
    @tags.push Tag[:css, src]
  end

  def resolve(path, type:)
    vite_asset_path(path, type:)
  end

  def load_tags
    @tags.map do |tag|
      case tag
      in [:js, src] then %[<script type="module" src="#{src}" crossorigin="#{@crossorigin}"></script>]
      in [:css, src] then %[<link rel="stylesheet" href="#{src}" />]
      end
    end.join
  end

  def preload_tags
    @tags.map do |tag|
      case tag
      in [:js, src] then %[<link rel="modulepreload" href="#{src}" as="script" crossorigin="#{@crossorigin}">]
      in [:css, src] then %[<link rel="preload" href="#{src}" as="style" />]
      end
    end.join
  end

  # Enables preloading, early hints are implemented in Puma and Falcon
  # With puma, run with puma --early-hints

  def send_early_hints
    return unless @env['rack.early_hints']

    early_hint_tags = @tags.map do |tag|
      case tag
      in [:js, src] then %[<#{src}>; rel=modulepreload; as=script; crossorigin=#{@crossorigin}]
      in [:css, src] then %[<#{src}>; rel=preload; as=style]
      end
    end

    @env['rack.early_hints'].call('Link' => early_hint_tags.join(', '))
  end

end
