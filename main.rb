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

class PageGenerator
  def initialize
    @go_rails_jobs = GoRailsScraper.new.scrape
  end

  def generate
    template = ERB.new File.read('index.html.erb')
    html = template.result(binding)
    File.write('index.html', html)
  end
end

page_generator = PageGenerator.new
page_generator.generate
