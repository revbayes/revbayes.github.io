module Tutorials
  class Generator < Jekyll::Generator
    def generate(site)
      
      tutorials = site.pages.find_all {|page| page.relative_path.match(/^tutorials/) != nil }
      site.config['tutorials'] = tutorials

      other = site.pages.find_all { |page| page['include_files'] != nil && page.relative_path.match(/^tutorials/) == nil}

      tutorials += other

      # label each file in a tutorial data/script directory
      tutorials.each do |tutorial|
        site.each_site_file do |file|
          # check if this file is one of the page's exclude_files
          exclude = false

          if tutorial.data['exclude_files']
            tutorial.data['exclude_files'].each do |exclude_file|
              next unless file.relative_path.match(Regexp.new(Regexp.escape(exclude_file)+"$"))
              exclude = true
              break
            end
            # skip if excluded
            next if exclude
          end

          tutorial_dir = tutorial.relative_path.sub(Regexp.new(Regexp.escape(tutorial.name)),'');
          
          type = nil
          if file.relative_path.match(Regexp.new(Regexp.escape(tutorial_dir+"data/")))
            type = 'data'
          elsif file.relative_path.match(Regexp.new(Regexp.escape(tutorial_dir+"scripts/")))
            type = 'script'
          elsif file.relative_path.match(Regexp.new(Regexp.escape(tutorial_dir+"example_output/")))
            type = 'example_output'
          end
          
          # include the file in its containing tutorial
          if type != nil and tutorial.data['include_all'] != false
            if type != 'example_output' or tutorial.data['include_example_output'] != false
              file.data['type'] = type
              tutorial.data['files'] = [] if tutorial.data['files'] == nil
              tutorial.data['files'] << file
            end
          end
        end
      end

      # fill in the tutorial files attribute
      tutorials.each do |tutorial|
        found_includes = {}
        found_excludes = {}

        # initialize includes to not found
        if tutorial.data['include_files']
          tutorial.data['include_files'].each do |include_file|
            found_includes[include_file] = false
          end
        end

        site.each_site_file do |file|
          # check if this file is one of the page's exclude_files
          exclude = false

          if tutorial.data['exclude_files']
            tutorial.data['exclude_files'].each do |exclude_file|
              next unless file.relative_path.match(Regexp.new(Regexp.escape(exclude_file)+"$"))
              exclude = true
              break
            end
            # skip if excluded
            next if exclude
          end

          # check if this file is one of the page's include_files
          if tutorial.data['include_files']
            tutorial.data['include_files'].each do |include_file|
              next unless include_file

              if file.relative_path.match(Regexp.new(Regexp.escape(include_file)+"$"))
                found_includes[include_file] = true

                tutorial.data['files'] = [] if tutorial.data['files'] == nil

                next if tutorial.data['files'].include? file

                tutorial.data['files'] << file
              end
            end
          end
        end

        found_includes.each do |key, value|
          unless value
            raise Jekyll::Errors::FatalException, <<-MSG
Could not locate file '#{key}' included in tutorial '#{tutorial.relative_path}'.
MSG
          end
        end

      end
    end
  end
end