module Jekyll
  module Tags
    class PageUrl < Liquid::Tag
	    VARIABLE_SYNTAX = %r!
	      (?<variable>[^{]*(\{\{\s*[\w\-\.]+\s*(\|.*)?\}\}[^\s{}]*)+)
	      (?<params>.*)
	    !x

		def initialize(tag_name, markup, tokens)
			super

			super
	        matched = markup.strip.match(VARIABLE_SYNTAX)
	        if matched
	          @page = matched["variable"].strip
	          @params = matched["params"].strip
	        else
	          @page, @params = markup.strip.split(%r!\s+!, 2)
	        end
	        @tag_name = tag_name
		end

	    def render_variable(context)
	        if @page.match(VARIABLE_SYNTAX)
	          partial = context.registers[:site]
	            .liquid_renderer
	            .file("(variable)")
	            .parse(@page)
	          partial.render!(context)
	        end
	    end

	    def render(context)
			site = context.registers[:site]

        	page = render_variable(context) || @page

	        site.pages.each do |item|
	        	return item.url if item.basename == page
	        end

	        raise ArgumentError, <<-MSG
Could not find page '#{page}' in tag '#{self.class.tag_name}'.
Make sure the page exists and the name is correct.
MSG
        end
    end
  end
end

Liquid::Template.register_tag('page_url', Jekyll::Tags::PageUrl)