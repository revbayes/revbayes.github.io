module Jekyll
  class HelpPage < Page
    def initialize(site, base, entry)
      @site = site
      @base = base
      @dir = site.config['helpdir']
      @name = entry['name']+'.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'help.html')
      self.data['entry'] = entry

      # get arguments
      arguments = entry['arguments']
      usage = entry['usage']

      if arguments.nil?
        unless entry['constructor'].nil?
          arguments = entry['constructor'].first['arguments']
          usage = entry['constructor'].first['usage']
        end
      end

      # build usage string
      usage_args = Array.new

      # hyperlink arguments
      unless arguments.nil?
        arguments.each do |argument|
          if argument['label'].nil?
            argument['label'] = "..."
          end

          type = argument['value_type'].gsub(/[\[\]]/,"")
          url = "<a href=\"#{dir}#{type}.html\">#{type}</a>"

          argument['value_type'] = argument['value_type'].gsub(type,url)
          usage_args.push argument['value_type']+" "+argument['label']
        end

        entry['usage'] = entry['name']+"("+usage_args.join(", ")+")"
      end

      # hyperlink methods
      unless entry['methods'].nil?
        entry['methods'].each do |method|
          # build usage string
          method_args = Array.new

          unless method['arguments'].nil?
            method['arguments'].each do |argument|
              if argument['label'].nil?
                argument['label'] = "..."
              end

              type = argument['value_type'].gsub(/[\[\]]/,"")
              url = "<a href=\"#{dir}#{type}.html\">#{type}</a>"

              argument['value_type'] = argument['value_type'].gsub(type,url)
              method_args.push argument['value_type']+" "+argument['label']
            end
          end

          method['usage'] = method['name']+"("+method_args.join(", ")+")"
        end
      end

      # hyperlink domain
      unless entry['domain'].nil?
        type = entry['domain'].gsub(/[\[\]]/,"")
        entry['domain'] = entry['domain'].gsub(type,"<a href=\"#{dir}#{type}.html\">#{type}</a>")
      end

      # hyperlink return_type
      unless entry['return_type'].nil?
        type = entry['return_type'].gsub(/[\[\]]/,"")
        entry['return_type'] = entry['return_type'].gsub(type,"<a href=\"#{dir}#{type}.html\">#{type}</a>")
      end

      #hyperlink see also types
      unless entry['see_also'].nil?
        if entry['see_also'].instance_of?(String)
          entry['see_also'] = "<a href=\"#{dir}#{entry['see_also']}.html\">#{entry['see_also']}</a>"
        else
          entry['see_also'].map! do |see|
            see = "<a href=\"#{dir}#{see}.html\">#{see}</a>"
          end
        end
      end
    end
  end

  class HelpPageGenerator < Generator
    safe true

    def generate(site)
      site.data['help'].each do |entry|
        site.pages << HelpPage.new(site, site.source, entry)
      end
    end
  end
end