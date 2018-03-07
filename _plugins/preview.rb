module Liquid
	class Preview < Block
		def initialize(tag_name, markup, options)
			super
			@tag_name,@markup,@options = tag_name,markup,options
		end

		def parse(tokenizer)
			@raw = Raw::parse(@tag_name, @markup, Marshal.load(Marshal.dump(tokenizer)), @options)

			super
		end

		def render(context)
			markdown = super(context).strip
			site = context.registers[:site]
  			converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
  			@raw = @raw.render(context)
  			@raw.gsub! '```', '26c84fecb586abdf357c2489a0f033e5'
			highlight = converter.convert("```markdown"+@raw+"```")
			highlight.gsub! '26c84fecb586abdf357c2489a0f033e5', '```'
			
			rendered = converter.convert(markdown)
			"<blockquote>#{highlight}<br>#{rendered}</blockquote>"
		end
	end
end

Liquid::Template.register_tag('preview', Liquid::Preview)