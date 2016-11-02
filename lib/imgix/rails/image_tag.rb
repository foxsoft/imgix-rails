require "imgix/rails/tag"

class Imgix::Rails::ImageTag < Imgix::Rails::Tag
  def render
    if @options[:lazy]
      @options[:"data-srcset"] = srcset
    else
      @options[:srcset] = srcset
    end
    @options[:sizes] ||= '100vw'

    @source = replace_hostname(@source)
    normal_opts = @options.slice!(*self.class.available_parameters)

    normal_url = ix_image_url(@source, @options)
    lazy_url = ix_image_url(@source, @options.merge({ blur: 1500, auto: "format,compress", q: 20, fm: "jpg" }))

    if @options[:lazy]
      normal_opts[:"data-src"] = ix_image_url(@source, @options)
    end

    image_tag(@options[:lazy] ? lazy_url : normal_url, normal_opts)
  end
end
