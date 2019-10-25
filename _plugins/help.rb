module Jekyll
  class HelpPage < Page
    def initialize(site, entry)
      @site = site
      @dir = site.config['helpdir']
      @name = entry['name']+'.html'

      self.process(@name)
      self.read_yaml(File.join(site.source, '_layouts'), 'help.html')
      self.data['entry'] = entry

      # set the entry type
      unless entry['type_spec'].nil?
        if entry['type_spec'].include? 'Function'
          entry['index'] = 'Function'
        elsif entry['type_spec'].include? 'Distribution'
          entry['index'] = 'Distribution'
        elsif entry['type_spec'].include? 'WorkspaceObject'
          if entry['type_spec'].include? 'Move'
            entry['index'] = 'Move'
          elsif entry['type_spec'].include? 'Monitor'
            entry['index'] = 'Monitor'
          else
            entry['index'] = 'Workspace'
          end
        else
          entry['index'] = 'ModelObject'
        end

        Array(entry['type_spec']).each do |type|
          if site.data['hierarchy'][type].nil?
            site.data['hierarchy'][type] = Hash.new
          end

          if site.data['hierarchy'][type]['derived'].nil?
            site.data['hierarchy'][type]['derived'] = Array.new
          end

          site.data['hierarchy'][type]['derived'] << entry['name']
        end
      end

      # add domain type
      unless entry['domain'].nil?
        if site.data['hierarchy'][entry['domain']].nil?
          site.data['hierarchy'][entry['domain']] = Hash.new
        end
      end

      # add return type
      unless entry['return_type'].nil?
        if site.data['hierarchy'][entry['return_type']].nil?
          site.data['hierarchy'][entry['return_type']] = Hash.new
        end
      end

      # get arguments
      arguments = entry['arguments']

      if arguments.nil?
        unless entry['constructor'].nil?
          arguments = entry['constructor'].first['arguments']
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
      site.data['hierarchy'] = Hash.new

      # find concrete types
      site.data['help'].each do |entry|
        site.data['hierarchy'][entry['name']] = Hash.new
        site.data['hierarchy'][entry['name']]['derived'] = Array.new
        site.data['hierarchy'][entry['name']]['concrete'] = true
        site.pages << HelpPage.new(site, entry)
      end

      # find abstract types
      site.data['hierarchy'].each_key do |type|
        unless site.data['hierarchy'][type]['concrete']
          abstract = Hash.new
          abstract['name'] = type
          abstract['derived'] = site.data['hierarchy'][type]['derived']
          site.pages << HelpPage.new(site, abstract)
        end
      end
    end
  end
end