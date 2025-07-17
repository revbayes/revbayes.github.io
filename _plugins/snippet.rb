def lines_match_in_order?(snippet_lines, file_lines)
  i = 0
  snippet_lines.each do |snippet_line|
    while i < file_lines.length && file_lines[i].strip != snippet_line.strip
      i += 1
    end
    return false if i == file_lines.length
    i += 1
  end
  true
end

module Liquid
	class Snippet < Block
		def initialize(tag_name, markup, options)
			super
                        @filename = markup.strip
		end

		def render(context)
                        code_block = super

                        code_lines = code_block.lines.map{ |l| l.strip }

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
                        match_found = lines_match_in_order?(code_lines, file_lines)

                        unless match_found
                          raise RuntimeError, "❌ Error: Code block not found in file `#{@filename}`:\n\n#{code_block}"
                        end

                        <<~MARKDOWN

                        #{code_block}

                        MARKDOWN
		end
	end
end

Liquid::Template.register_tag('snippet', Liquid::Snippet)
