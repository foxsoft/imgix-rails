require "imgix/rails/tag"

class Imgix::Rails::ImageTag < Imgix::Rails::Tag
  REMOVE_ATTRIBUTES = [:lazy, :max_width].freeze
  def render
    is_lazy = @options[:lazy]
    if is_lazy
      @options[:"data-srcset"] = srcset
    else
      @options[:srcset] = srcset
    end
    @options[:sizes] ||= '100vw'

    @source = replace_hostname(@source)
    normal_opts = (@options.slice!(*self.class.available_parameters))
    REMOVE_ATTRIBUTES.each { |attribute| normal_opts.delete(attribute) }

    if is_lazy
      normal_opts[:"data-src"] = ix_image_url(@source, @options)
      normal_opts[:class] = "#{normal_opts[:class].to_s} lazyload"
      image_tag(ix_image_url(@source, @options.merge({ blur: 300, px: 10, auto: "format,compress", q: 20, fm: "jpg" })), normal_opts)
    else
      image_tag(ix_image_url(@source, @options), normal_opts)
    end

  end
end
