module Jekyll
  module Filters
	    def get_page(input)
			site = @context.registers[:site]

	        site.pages.each do |item|
	        	return item if item.basename == input
	        end

	        raise ArgumentError, <<-MSG
Could not find page '#{page}' in tag '#{self.class.tag_name}'.
Make sure the page exists and the name is correct.
MSG
        end
  end
end