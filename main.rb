require 'debug'
require 'erb'
require 'json'

Dir.new('./scrapers').children.each do |file|
  require_relative "./scrapers/#{file}"
end

class SiteBuilder
  attr_reader :site_names, :pages

  def initialize
    @site_names = ["GoRails", "WeWorkRemotely", "RubyOnRemote",
                   "RubyOnRailsJobs", "RailsHotwireJobs", "WeAreHiring"]
    @pages = {}
  end

  def create_site
    site_names.each do |name|
      page = Object.const_get(name).new
      page.scrape_and_generate_page
      pages[name.downcase.to_s] = page
    end

    File.open('jobs.json', 'w') do |f|
      all_jobs = []
      pages.each do |key, val|
        all_jobs << val.jobs
      end
      f.write(JSON.dump(all_jobs))
    end
  end
end

sb = SiteBuilder.new
sb.create_site
