require 'jekyll-scholar'

module Jekyll
  class Scholar

	class CitetTag < Liquid::Tag
		include Scholar::Utilities

		def initialize(tag_name, arguments, tokens)
	        super
	        arguments += " --style assets/systematic-biology-in-text.csl"
	        
	        @config = Scholar.defaults.dup
	        @keys, arguments = split_arguments(arguments)

	        optparse(arguments)
	    end

		def render(context)
	    	set_context_to context
	    	cite keys
	    end
	end
  end
end

Liquid::Template.register_tag('citet', Jekyll::Scholar::CitetTag)