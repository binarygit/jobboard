require 'nokogiri'
require 'open-uri'
require 'debug'
require 'erb'

class GoRailsScraper
  attr_reader :base_url

  def initialize
    @base_url = 'https://jobs.gorails.com'
  end

  def scrape
    doc = Nokogiri::HTML( URI.open(base_url) )
    job_postings = doc.css('body > div li')
    jobs = []

    job_postings.each do |job|
      anchor_tag = job.at_css('a')
      hash = {}
      hash[:href] = base_url + anchor_tag['href']

      title_element = job.at_css('h3')
      hash[:title] = title_element.text
      jobs << hash

      misc = job.at_css('div.w-full.truncate').css('div')[3]
      hash[:misc] = misc.text.strip.gsub("\n", " ")
    end
    jobs
  end
end

class WeWorkRemotelyScraper
  attr_reader :base_url, :scrap_url

  def initialize
    @scrap_url = 'https://weworkremotely.com/remote-ruby-on-rails-jobs'
    @base_url = 'https://weworkremotely.com'
  end

  def scrape
    doc = Nokogiri::HTML( URI.open(scrap_url) )
    job_postings = doc.css('.jobs li')
    # The last element is an li containing the link
    # to "back to all jobs"
    # so we discard it
    job_postings.pop
    jobs = []

    job_postings.each do |job|
      anchor_tag = job.css('a')[1]
      hash = {}
      hash[:href] = base_url + anchor_tag['href']

      title = job.at_css('.title').text
      hash[:title] = title

      type = job.css('.company')[1].text
      region = job.at_css('.region.company').text
      hash[:misc] = type + "/" + region
      jobs << hash
    end
    jobs
  end
end

class PageGenerator
  def initialize
    @go_rails_jobs = GoRailsScraper.new.scrape
    @wwr_jobs = WeWorkRemotelyScraper.new.scrape
    @pages = [{ jobs: @go_rails_jobs, file_name: 'gorails.html' },
              { jobs: @wwr_jobs, file_name: 'weworkremotely.html' }]

  end

  def generate
    @pages.each do |page|
      jobs = page[:jobs]
      template = ERB.new File.read('templates/index.html.erb')
      html = template.result(binding)
      File.write("templates/#{page[:file_name]}", html)
    end
  end
end

page_generator = PageGenerator.new
page_generator.generate
