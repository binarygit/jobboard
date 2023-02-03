require 'debug'
require 'erb'
Dir.new('./scrapers').children.each do |file|
  require_relative "./scrapers/#{file}"
end

class PageGenerator
  def generate(page)
    jobs = page[:jobs]
    template = ERB.new File.read('templates/index.html.erb')
    html = template.result(binding)
    File.write("templates/#{page[:file_name]}", html)
  end
end

gorails_jobs = GoRailsScraper.new.scrape
wwr_jobs = WeWorkRemotelyScraper.new.scrape
ror_jobs = RubyOnRailsJobsScraper.new.scrape
ruby_on_remote_jobs = RubyOnRemoteScraper.new.scrape
pages = [{ jobs: gorails_jobs, file_name: 'gorails.html' },
         { jobs: wwr_jobs, file_name: 'weworkremotely.html' },
         { jobs: ror_jobs, file_name: 'rorjobs.html' },
         { jobs: ruby_on_remote_jobs, file_name: 'rubyonremote.html' },
]

page_generator = PageGenerator.new
pages.each do |page|
  page_generator.generate(page)
end
