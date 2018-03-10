module RevBayes
  module Filters
      VARIABLE_SYNTAX = %r!
        (?<variable>[^{]*(\{\{\s*[\w\-\.]+\s*(\|.*)?\}\}[^\s{}]*)+)
        (?<params>.*)
      !x

      def match_page(page_identifier)
        site = @context.registers[:site]

        if page_identifier.match(VARIABLE_SYNTAX)
          partial = site
            .liquid_renderer
            .file("(variable)")
            .parse(page_identifier)

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
  end
end

Liquid::Template.register_filter(RevBayes::Filters)