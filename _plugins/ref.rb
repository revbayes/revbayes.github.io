module Liquid
	class Ref < Tag
		def initialize(tag_name, id, tokens)
			super
			@id = id.strip
		end

		def render(context)
			"<a href=\"##{@id}\"></a>"
		end
	end
end

Liquid::Template.register_tag('ref', Liquid::Ref)