require './_plugins/filters.rb'

module RevBayes
  module Tags
  	class PageRef < Liquid::Tag
      include RevBayes::Filters

      def initialize(tag_name, markup, tokens)
				super
			end

			def render(context)
        @context = context
				site = @context.registers[:site]

				page = match_page(@markup.strip)

				"<a href=\"#{site.baseurl+page.url}\">#{page['title']}</a>"
      end
    end

    class PageUrl < Liquid::Tag
      include RevBayes::Filters

	    def initialize(tag_name, markup, tokens)
				super
			end

			def render(context)
        @context = context
        site = @context.registers[:site]

				site.baseurl+match_page(@markup.strip).url
      end
    end

  end
end

Liquid::Template.register_tag('page_ref', RevBayes::Tags::PageRef)
Liquid::Template.register_tag('page_url', RevBayes::Tags::PageUrl)
