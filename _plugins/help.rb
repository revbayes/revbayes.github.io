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

      unless arguments.nil?
        arguments.each do |argument|
          if argument['label'].nil?
            argument['label'] = "..."
          end

          # hyperlink argument types
          type = argument['value_type'].gsub(/[\[\]]/,"")
          url = "<a href=\"#{dir}#{type}.html\">#{type}</a>"

          argument['value_type'] = argument['value_type'].gsub(type,url)
          usage_args.push argument['value_type']+" "+argument['label']
        end

        entry['usage'] = entry['name']+"("+usage_args.join(", ")+")"
      end

      # build methods strings
      unless entry['methods'].nil?
        entry['methods'].each do |method|
          # build usage string
          method_args = Array.new

          unless method['arguments'].nil?
            method['arguments'].each do |argument|
              if argument['label'].nil?
                argument['label'] = "..."
              end

              # hyperlink method argument types
              type = argument['value_type'].gsub(/[\[\]]/,"")
              url = "<a href=\"#{dir}#{type}.html\">#{type}</a>"

              argument['value_type'] = argument['value_type'].gsub(type,url)
              method_args.push argument['value_type']+" "+argument['label']
            end
          end

          method['usage'] = method['name']+"("+method_args.join(", ")+")"
        end
      end
    end
  end

  class HelpPageGenerator < Generator
    safe true

    def generate(site)
    	unless site.data['help'].nil?
	      entries = Hash.new

	      # copy entries for concrete types
	      site.data['help'].each do |entry|
          entries[entry['name']] = entry
        end

        # create entries for abstract types
        site.data['help'].each do |entry|
          # add domain type
          if not entry['domain'].nil? and entries[entry['domain']].nil?
            entries[entry['domain']] = Hash.new
            entries[entry['domain']]['name'] = entry['domain']
          end

          # add return type
          if not entry['return_type'].nil? and entries[entry['return_type']].nil?
            entries[entry['return_type']] = Hash.new
            entries[entry['return_type']]['name'] = entry['return_type']
          end

          # add moves to types
          unless entry['type_spec'].nil?
            if entry['type_spec'].include? 'Move'
              unless entry['constructor'].nil?
                type = entry['constructor'].first['arguments'].first()['value_type'].gsub(/[\[\]]/,"")
                unless entry[type].nil?
                  if entries[type]['moves'].nil?
                    entries[type]['moves'] = Array.new
                  end

                  entries[type]['moves'] << entry['name']
                end
              end
            end
          end

          # add distributions to types
          unless entry['type_spec'].nil?
            if entry['type_spec'].include? 'Distribution'
              unless entry['domain'].nil?
                type = entry['domain']
                if entries[type]['distributions'].nil?
                  entries[type]['distributions'] = Array.new
                end

                entries[type]['distributions'] << entry['name']
              end
            end
          end

          # build type hierarchy
	        Array(entry['type_spec']).each do |type|
            if entries[type].nil?
              entries[type] = Hash.new
              entries[type]['name'] = type
            end

            # add derived types
            if entries[type]['derived'].nil?
              entries[type]['derived'] = Array.new
            end

            entries[type]['derived'] << entry['name']
          end
	      end

        # generate help pages
	      entries.each_key do |type|
	        site.pages << HelpPage.new(site, entries[type])
	      end
	    end
    end
  end
end
