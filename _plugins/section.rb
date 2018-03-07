module Liquid
	class Section < Tag
		include Liquid::StandardFilters
		def initialize(tag_name, arguments, tokens)
			super
			@title, @id = arguments.split(/(?<!\\)\|/)
			@title = @title.strip
			@id = @id.strip
			@h = (tag_name == 'section' ? '2' : '3')
		end

		def render(context)
			site = context.registers[:site]
  			converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
			content = converter.convert(@title)
			content = remove(content, '<p>')
			content = remove(content, '</p>')
			content = content.strip

			output = "<h#{@h} class=\"section\" id=\"#{@id}\">#{content}</h#{@h}>"

			if @h == '2'
				output += "<hr>"
			end
			
			output
		end
	end
end

Liquid::Template.register_tag('section', Liquid::Section)
Liquid::Template.register_tag('subsection', Liquid::Section)