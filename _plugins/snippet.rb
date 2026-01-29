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

      check_sequence(code_lines, file_lines, code_block)

      <<~MARKDOWN
      ```
      #{code_block.strip}
      ```
      MARKDOWN
    end


    private

    def check_sequence(snippet, source, original_block)
      current_index = 0
      snippet.each do |line|
        # Find the next occurrence of the line after the previous match
        found_index = source[current_index..-1].index(line)
        
        if found_index.nil?
          raise "❌ Line not found in `#{@filename}` (or out of order):\n'#{line}'"
        end
        
        # Move the pointer forward
        current_index += found_index + 1
      end
    end
    
  end
end

Liquid::Template.register_tag('snippet', Liquid::Snippet)
