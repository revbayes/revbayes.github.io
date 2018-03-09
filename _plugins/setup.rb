module Tutorials
  class Generator < Jekyll::Generator
    def generate(site)
      tutorials = site.pages.find_all {|page| page['layout'] == "tutorial" or page['permalink'] == "/developer/tutorial/" }

      tutorials.each do |tutorial|
        found_includes = {}
        found_excludes = {}

        if tutorial.data['include_files']
          tutorial.data['include_files'].each do |include_file|
            found_includes[include_file] = false
          end
        end

        site.each_site_file do |file|
          exclude = false
          if tutorial.data['exclude_files']
            tutorial.data['exclude_files'].each do |exclude_file|
              next unless file.relative_path.match(Regexp.new(Regexp.escape(exclude_file)+"$"))
              exclude = true
            end
            next if exclude
          end

          page_file = false
          if file.relative_path.match(Regexp.new(Regexp.escape(tutorial.dir+"data/")))
            page_file = true
          	tutorial.data['data_files'] = [] if tutorial['data_files'] == nil
          	tutorial.data['data_files'] << file
          end
          if file.relative_path.match(Regexp.new(Regexp.escape(tutorial.dir+"scripts/")))
            page_file = true
          	tutorial.data['scripts'] = [] if tutorial['scripts'] == nil
          	tutorial.data['scripts'] << file
          end

          next if page_file

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