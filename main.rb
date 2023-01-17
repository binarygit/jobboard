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
  attr_reader :base_url

  def initialize
    @base_url = 'https://weworkremotely.com/remote-ruby-on-rails-jobs'
  end

  def scrape
    doc = Nokogiri::HTML( URI.open(base_url) )
    job_postings = doc.css('.jobs li')
    # The last element is an li containing the link
    # to "back to all jobs"
    # so we discard it
    job_postings.pop
    # Redefine the base url so that
    # href links are correct
    @base_url = 'https://weworkremotely.com'
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

class RubyOnRailsJobsScraper
  attr_reader :base_url

  def initialize
    @base_url = 'https://www.ruby-on-rails-jobs.com'
  end

  def scrape
    doc = Nokogiri::HTML( URI.open(base_url) )
    job_postings = doc.css('div[id^=job]')
    jobs = []

    job_postings.each do |job|
      anchor_tag = job.at_css('a')
      hash = {}
      hash[:href] = base_url + anchor_tag['href']

      title = job.at_css('span.h5 + span').text
      hash[:title] = title

      misc = job.at_css('div:last-child').at_css('div:last-child').text
      hash[:misc] = misc.strip.gsub("\n", " ")
      jobs << hash
    end
    jobs
  end
end

class PageGenerator
  def initialize
    @go_rails_jobs = GoRailsScraper.new.scrape
    @wwr_jobs = WeWorkRemotelyScraper.new.scrape
    @ror_jobs = RubyOnRailsJobsScraper.new.scrape
    @pages = [{ jobs: @go_rails_jobs, file_name: 'gorails.html' },
              { jobs: @wwr_jobs, file_name: 'weworkremotely.html' },
              { jobs: @ror_jobs, file_name: 'rorjobs.html' },
    ]

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
