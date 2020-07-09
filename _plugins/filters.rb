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
        
        matches = site.static_files.find_all {|file| file.relative_path.match(Regexp.new(file_string)) }

        if matches.size > 1
          raise ArgumentError, <<-MSG
Multiple files match '#{file_identifier}'
MSG
        elsif matches.size > 0
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

        matches = site.pages.find_all {|page| page.relative_path.match(Regexp.new(page_string)) }

        if matches.size > 1
          raise ArgumentError, <<-MSG
Multiple pages match '#{page_identifier}' in #{tag_string}
MSG
        elsif matches.size > 0
          return matches[0]
        end
        
        raise ArgumentError, <<-MSG
Could not find page '#{page_identifier}' in #{tag_string}
MSG
      end

      def snippet(file,type,number)
        site = @context.registers[:site]

        if not file.instance_of? Jekyll::Drops::StaticFileDrop
          file = match_file(file)
        end

        content = File.read(site.in_source_dir(file.path))

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
          if to > content.lines.count
            raise ArgumentError, <<-MSG
Line number out of range in 'snippet' filter
MSG
          end

          i = 1
          for line in content.each_line do
            ret += line if range.include? i
            i += 1
          end

          "```\n"+ret+"```"
        elsif type =~ /^block/
          i = 1
          
          if m = type.match(/block(.)$/)
            content = content.gsub(Regexp.new('^\s*'+m[1]+'.*'),'')
          end

          content = content.gsub(/\A\n*/m,'')

          for block in content.gsub(/\n\n+/m,"\n\n").each_line("\n\n") do
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
  end
end

Liquid::Template.register_filter(RevBayes::Filters)