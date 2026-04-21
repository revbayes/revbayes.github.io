module RevBayes
  module Filters
      VARIABLE_SYNTAX = %r!
        (?<variable>[^{]*(\{\{\s*[\w\-\.]+\s*(\|.*)?\}\}[^\s{}]*)+)
        (?<params>.*)
      !x

      def match_file(file_identifier)
        site = @context.registers[:site]
        page = @context.registers[:page]

        if file_identifier.match(VARIABLE_SYNTAX)
          partial = Liquid::Template.parse(file_identifier)

          file_identifier = partial.render!(@context)
        end

        file_string = file_identifier.sub(/^(?!\/)/,'/').sub(/^(\/tutorials)?\//,'/').gsub(/\//,'\/')
        
        site.config['file_match_cache'] ||= {}
        if hit = site.config['file_match_cache'][file_string]
          return hit
        end

        matches = site.static_files.find_all {|file| file.relative_path.match(Regexp.new(file_string)) }

        if matches.size > 1
          raise ArgumentError, <<-MSG
Multiple files match '#{file_identifier}'
MSG
        elsif matches.size > 0
          site.config['file_match_cache'][file_string] = matches[0]
          return matches[0]
        end
        
        raise ArgumentError, <<-MSG
Could not find file '#{file_identifier}'
MSG
      end

      def match_page(page_identifier)
        site = @context.registers[:site]

        if page_identifier.match(VARIABLE_SYNTAX)
          partial = Liquid::Template.parse(page_identifier)

          page_identifier = partial.render!(@context)
        end

        page_string = page_identifier.sub(/\/$/,'').sub(/^(?!\/)/,'/').sub(/^(\/tutorials)?\//,'/').gsub(/\//,'\/').sub(/(?<!\.md)$/,'(\/index)?\.md$')
        
        tag_string = @tag_name ? "tag '"+@tag_name+"'" : "filter 'match_page'"

        site.config['page_match_cache'] ||= {}
        if hit = site.config['page_match_cache'][page_string]
          return hit
        end

        matches = site.pages.find_all {|page| page.relative_path.match(Regexp.new(page_string)) }

        if matches.size > 1
          raise ArgumentError, <<-MSG
Multiple pages match '#{page_identifier}' in #{tag_string}
MSG
        elsif matches.size > 0
          site.config['page_match_cache'][page_string] = matches[0]
          return matches[0]
        end
        
        raise ArgumentError, <<-MSG
Could not find page '#{page_identifier}' in #{tag_string}
MSG
      end

      def parse_range_string(str)
        str.split(',').flat_map do |chunk|
          if chunk.include?('-')
            start_str, end_str = chunk.split('-', 2)
            starti = Integer(start_str)
            endi = Integer(end_str)
            if starti > endi
              raise ArgumentError, "Line number #{starti} > #{endi} in 'snippet' filter"
            end
            (starti..endi).to_a
          else
            [Integer(chunk)]
          end
        end
      end

      def snippet(file,type,number)
        site = @context.registers[:site]

        if not file.instance_of? Jekyll::Drops::StaticFileDrop
          file = match_file(file)
        end

        site.config['file_content_cache'] ||= {}
        content = site.config['file_content_cache'][file.path] ||= File.read(site.in_source_dir(file.path))

        ret = ""

        from,to = number.split('-')
        to = from if to == nil

        from,to = from.to_i,to.to_i

        if from > to
          raise ArgumentError, <<-MSG
Line number from > to in 'snippet' filter
MSG
        end

        range = from..to

        if type =~ /^line/
          site.config['snippet_lines_filter_cache'] ||= {}
          lines = site.config['snippet_lines_filter_cache'][file.path] ||= content.lines.to_a
          
          if to > lines.count
            raise ArgumentError, "Line number out of range in 'snippet' filter"
          end

          i = 1
          for line in lines do
            ret += line if range.include? i
            i += 1
          end

          "```\n"+ret+"```"
        elsif type =~ /^block/
          i = 1
          
          site.config['snippet_blocks_cache'] ||= {}
          cache_key = "#{file.path}_#{type}"
          
          blocks = site.config['snippet_blocks_cache'][cache_key]
          if blocks.nil?
            processed_content = content.dup
            if m = type.match(/block(.)$/)
              processed_content = processed_content.gsub(Regexp.new('^\s*'+m[1]+'.*'),'')
            end
            processed_content = processed_content.gsub(/\A\n*/m,'')
            blocks = processed_content.gsub(/\n\n+/m,"\n\n").each_line("\n\n").to_a
            site.config['snippet_blocks_cache'][cache_key] = blocks
          end

          for block in blocks do
            ret += block if range.include? i
            i += 1
          end

          "```\n"+ret.sub(/\n*\z/,'')+"\n```"
        else
          raise ArgumentError, <<-MSG
Unknown option '#{type}' for 'snippet' filter
MSG
        end
      end

      def tagged_snippet(file, tag, range)
        site = @context.registers[:site]

        if not file.instance_of? Jekyll::Drops::StaticFileDrop
          file = match_file(file)
        end

        site.config['file_content_cache'] ||= {}
        content = site.config['file_content_cache'][file.path] ||= File.read(site.in_source_dir(file.path))

        ret = ""

        range = parse_range_string(range)

        tag_pattern = Regexp.new('^\s*' + Regexp.escape(tag))

        if content.scan(tag_pattern).size > 1
          raise "Error: tag '#{tag}' occurred more than once in file '#{file}'"
        elsif content.scan(tag_pattern).size < 1
          raise "Error: tag '#{tag}' not found in file '#{file}'"
        end

        # remove content from the string before the pattern
        content = content.sub(/.*?(#{tag_pattern})/m, '\1')
        content = content.sub(/\A\s*\n*/, '')

        i = 0
        for line in content.each_line do
          ret += line if range.include? i
          i += 1
        end

        # strip final newlines and put the content between backticks
        "```\n"+ret.sub(/\n*\z/,'')+"\n```"
      end
  end
end

Liquid::Template.register_filter(RevBayes::Filters)
