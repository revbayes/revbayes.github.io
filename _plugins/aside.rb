module Liquid
	class Aside < Block
		include StandardFilters

		def initialize(tag_name, markup, options)
			super
			@tag_name,@markup,@options = tag_name,markup,options
		end

		def parse(tokenizer)
			@raw = Raw::parse(@tag_name, '', Marshal.load(Marshal.dump(tokenizer)), @options)

			super
		end

		def render(context)
			markdown = super(context).strip
			site = context.registers[:site]
  		converter = site.find_converter_instance(::Jekyll::Converters::Markdown)	
			header = converter.convert(@markup)
			header = remove(header, '<p>')
			header = remove(header, '</p>')
			header = header.strip
			rendered = converter.convert(markdown)
			"<blockquote class=\"aside\"><h2>#{header}</h2>#{rendered}</blockquote>"
		end
	end
end

Liquid::Template.register_tag('aside', Liquid::Aside)