module Tutorials
  class Generator < Jekyll::Generator
    def generate(site)
      
      tutorials = site.pages.find_all {|page| page.relative_path.match(/^tutorials/) != nil }
      site.config['tutorials'] = tutorials

      developer = site.pages.find { |page| page['permalink'] == "/developer/tutorial"}

      # add the developer tutorial separately so it doesn't go in site.tutorials
      tutorials << developer

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
            end
            next if exclude
          end

          tutorial_dir = tutorial.relative_path.sub(Regexp.new(Regexp.escape(tutorial.name)),'');

          # check if this file is in one of the page's files directories
          page_file = false
          if file.relative_path.match(Regexp.new(Regexp.escape(tutorial_dir+"data/")))
            page_file = true
          	tutorial.data['data_files'] = [] if tutorial['data_files'] == nil
          	tutorial.data['data_files'] << file
          end
          if file.relative_path.match(Regexp.new(Regexp.escape(tutorial_dir+"scripts/")))
            page_file = true
          	tutorial.data['scripts'] = [] if tutorial['scripts'] == nil
          	tutorial.data['scripts'] << file
          end
          next if page_file

          # check if this file is one of the page's include_files
          if tutorial.data['include_files']
          	tutorial.data['include_files'].each do |include_file|

          	  if file.relative_path.match(Regexp.new(Regexp.escape(include_file)+"$"))
                found_includes[include_file] = true
          	  	matches = file.relative_path.match(/tutorials\/[^\/]+\/([^\/]+)/)
          	  	if matches[1] == 'data'
          	  	  tutorial.data['data_files'] = [] if tutorial.data['data_files'] == nil
          	      tutorial.data['data_files'] << file
          	    elsif matches[1] == 'scripts'
          	      tutorial.data['scripts'] = [] if tutorial.data['scripts'] == nil
          	      tutorial.data['scripts'] << file
          	    else
                  tutorial.data['other'] = [] if tutorial.data['other'] == nil
          	      tutorial.data['other'] << file
          	    end
          	  end
          	end
          end
        end

        found_includes.each do |key, value|
          unless value
            raise Jekyll::Errors::FatalException, <<-MSG
Could not locate file '#{key}' included in tutorial '#{tutorial.name}'.
MSG
          end
        end

      end
    end
  end
end