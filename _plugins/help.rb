module Jekyll
  class HelpPage < Page
    def initialize(site, base, dir, entry)
      @site = site
      @base = base
      @dir = dir
      @name = entry['name']+'.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'documentation.html')
      self.data['entry'] = entry
    end
  end

  class HelpPageGenerator < Generator
    safe true

    def generate(site)
      site.data['help'].each_key do |category|
        site.data['help'][category].each do |entry|
          site.pages << HelpPage.new(site, site.source, File.join("docs", category), entry)
        end
      end
    end
  end
end