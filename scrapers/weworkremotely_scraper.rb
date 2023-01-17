#!/usr/bin/ruby
require 'nokogiri'
require 'open-uri'

class WeWorkRemotelyScraper
  attr_reader :base_url

  def initialize
    @base_url = 'https://weworkremotely.com/remote-ruby-on-rails-jobs'
  end

  def scrape
    doc = Nokogiri::HTML(URI.open(base_url))
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
