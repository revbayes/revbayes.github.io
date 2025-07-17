module Liquid
	class Snippet < Block
		def initialize(tag_name, markup, options)
			super
                        @filename = markup.strip
		end

		def render(context)
                        code_block = super.strip
                        code_lines = code_block.lines.map{ |l| l.strip }

                        # Site source directory (so we don't need absolute paths)
                        current_page_path = context.registers[:page]["path"]    # e.g., "docs/example.md"
                        page_dir = File.dirname(current_page_path)               # => "docs"

                        # Resolve snippet file relative to the document
                        site_source = context.registers[:site].source
                        file_path = File.expand_path(File.join(site_source, page_dir, @filename))
  
                        unless File.exist?(file_path)
#                          return "❌ Error: File '#{@filename}' not found at #{file_path}."
                          raise IOError, "❌ Error: File '#{@filename}' not found at #{file_path}."
                        end

                        file_lines = File.readlines(file_path).map{ |l| l.strip }

                        # Search for exact match of code_lines in file_lines
                        match_found = false
                        (0..(file_lines.length - code_lines.length)).each do |start_idx|
                          if file_lines[start_idx, code_lines.length] == code_lines
                            match_found = true
                            break
                          end
                        end

                        unless match_found
#                          return "❌ Error: Code block not found in file `#{@filename}`:\n\n#{code_block}"
                          raise RuntimeError, "❌ Error: Code block not found in file `#{@filename}`:\n\n#{code_block}"
                        end

                        <<~MARKDOWN


                        ```
                        #{code_block}
                        ```

                        MARKDOWN
		end
	end
end

Liquid::Template.register_tag('snippet', Liquid::Snippet)
