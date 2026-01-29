module Liquid
	class Snippet < Block
		def initialize(tag_name, markup, options)
			super
                        @filename = markup.strip
		end

		def render(context)
                        code_block = super.strip

                        # Drop blank lines and comment lines
                        code_lines = code_block.lines.filter_map{ |l| l.strip unless (l.strip.empty? or l.strip.start_with?('#'))}

                        # Site source directory (so we don't need absolute paths)
                        current_page_path = context.registers[:page]["path"]    # e.g., "docs/example.md"
                        page_dir = File.dirname(current_page_path)               # => "docs"

                        # Resolve snippet file relative to the document
                        site_source = context.registers[:site].source
                        file_path = File.expand_path(File.join(site_source, page_dir, @filename))

                        unless File.exist?(file_path)
                          raise IOError, "❌ Error: File '#{@filename}' not found at #{file_path}."
                        end

                        file_lines = File.readlines(file_path).map{ |l| l.strip }
                        
                        # Search for exact match of code_lines in file_lines
                        i = 0
                        code_lines.each do |snippet_line|
                          while i < file_lines.length && file_lines[i].strip != snippet_line.strip
                            i += 1
                          end
                          if i == file_lines.length
                            raise RuntimeError, "❌ Error: line for code block not found in file `#{@filename}`:\n\n#{snippet_line}\n\nin block:\n#{code_block}"
                          end
                          i += 1
                        end
                        
                        <<~MARKDOWN
                        ```
                        #{code_block.strip}
                        ```
                        MARKDOWN
		end
	end
end

Liquid::Template.register_tag('snippet', Liquid::Snippet)
