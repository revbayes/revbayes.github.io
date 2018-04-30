module Liquid
	class Section < Tag
		include StandardFilters

		def initialize(tag_name, arguments, tokens)
			super
			@title, @id = arguments.split(/(?<!\\)\|/)

			@title = @title = nil ? "" : @title.strip
			if @id == nil
				@id = @title.strip.downcase.gsub(/[^\w\- ]+/, '').gsub(/\s/, '-').gsub(/\-+$/, '')
			else
				@id = @id.strip
			end
			
			@tag_name = tag_name
			@h = (tag_name == 'section' ? '2' : tag_name == 'subsection' ? '3' : '4')
		end

		def render(context)
			site = context.registers[:site]
  			converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
			content = converter.convert(@title)
			content = remove(content, '<p>')
			content = remove(content, '</p>')
			content = content.strip

			output = "<h#{@h} class=\"#{@tag_name}\" id=\"#{@id}\">#{content}</h#{@h}>"

			output += "<hr class=\"#{@tag_name}\">"
			
			output
		end
	end
end

Liquid::Template.register_tag('section', Liquid::Section)
Liquid::Template.register_tag('subsection', Liquid::Section)
Liquid::Template.register_tag('subsubsection', Liquid::Section)