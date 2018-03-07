module Liquid
	class Figure < Block
		def initialize(tag_name, id, tokens)
			super
			@id = id.strip
		end

		def render(context)
			markdown = super(context).strip
			site = context.registers[:site]
  			converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
			figure_main = converter.convert(markdown)

			output = "<figure id=\"#{@id}\">#{figure_main}</figure>"

			return output
		end
	end

	class FigureCaption < Block
		include StandardFilters

		def initialize(tag_name, markup, tokens)
			super
		end

		def render(context)
			markdown = super(context).strip
			site = context.registers[:site]
  			converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
			caption = converter.convert(markdown)
			caption = remove(caption, '<p>')
			caption = remove(caption, '</p>')
			caption = caption.strip

			"<figcaption>#{caption}</figcaption>"
		end
	end
end

Liquid::Template.register_tag('figure', Liquid::Figure)
Liquid::Template.register_tag('figcaption', Liquid::FigureCaption)