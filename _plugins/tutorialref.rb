module Liquid
	class TutorialRef < Liquid::Tag
		def initialize(tag_name, markup, tokens)
			super
			@tutorial = markup.strip
			tutorial_name = @tutorial.gsub(/(^\"|\"$)/, '')

			if @tutorial != tutorial_name
			 	@string = true
			 	@tutorial = tutorial_name
			else
				@string = false
			end
		end

		def render(context)
        
	        tutorial_name = @tutorial

	        unless @string
	        	tutorial_name = context[@tutorial]
	        end

	        site = context.registers[:site]
	        site.each_site_file do |item|
	        	if item.respond_to?(:[]) and item['title'] != nil
		        	link = "<a href=\"#{site.baseurl+item.url}\">#{item['title']}</a>"
					return link if item.basename == tutorial_name
				end
	        end

	        raise ArgumentError, <<-MSG
Could not find tutorial '#{tutorial_name}' in tag '#{self.class.tag_name}'.
Make sure the tutorial exists and the name is correct.
MSG
      end
	end
end

Liquid::Template.register_tag('tutorialref', Liquid::TutorialRef)