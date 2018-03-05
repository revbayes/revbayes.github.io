module Jekyll
	class FigureTag < Liquid::Block
		include Liquid::StandardFilters
		def initialize(tag_name, id, tokens)
			super
			@id = id.strip
		end

		def render(context)
			site = context.registers[:site]
  			converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
			figure_main = converter.convert(super(context))
			figure_main = remove(figure_main, '<p>')
			figure_main = remove(figure_main, '</p>')

			output = "<figure id=\"#{@id}\">#{figure_main}</figure>"

			return output
		end
	end

	class FigureCaptionTag < Liquid::Block
		include Liquid::StandardFilters
		def initialize(tag_name, markup, tokens)
			super
		end

		def render(context)
			site = context.registers[:site]
  			converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
			caption = converter.convert(super(context))
			caption = remove(caption, '<p>')
			caption = remove(caption, '</p>')

			output = "<figcaption>#{caption}</figcaption>"

			return output
		end
	end

	class FigureRefTag < Liquid::Tag
		def initialize(tag_name, id, tokens)
			super
			@id = id.strip
		end

		def render(context)
			output = "<a href=\"##{@id}\"></a>"

			return output
		end
	end
end

Liquid::Template.register_tag('figure', Jekyll::FigureTag)

Liquid::Template.register_tag('figcaption', Jekyll::FigureCaptionTag)

Liquid::Template.register_tag('figureref', Jekyll::FigureRefTag)
Liquid::Template.register_tag('figref', Jekyll::FigureRefTag)