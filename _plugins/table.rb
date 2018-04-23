module Liquid
	class Table < Block
		def initialize(tag_name, id, tokens)
			super
			@id = id.strip
		end

		def render(context)
			markdown = super(context).strip
			site = context.registers[:site]
  			converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
			figure_main = converter.convert(markdown)

			output = "<figure id=\"#{@id}\" class=\"table\">#{figure_main}</figure>"

			return output
		end
	end

	class TableCaption < Block
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

			"<figcaption class=\"table\">#{caption}</figcaption>"
		end
	end
end

Liquid::Template.register_tag('table', Liquid::Table)
Liquid::Template.register_tag('tabcaption', Liquid::TableCaption)