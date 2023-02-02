#!/usr/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'debug'

class RubyOnRemoteScraper
  attr_reader :base_url

  def initialize
    @base_url = 'https://rubyonremote.com'
    @scrap_path = '/remote-jobs/'
  end

  def scrape
    all_jobs = []
    (1..2).each do |page_num|
      doc = Nokogiri::HTML(URI.open(get_scrap_url(page_num)))
      job_postings = doc.css("a[href^='/jobs']")
      jobs = []

      job_postings.each do |job|
        anchor_tag = job
        hash = {}
        hash[:href] = base_url + anchor_tag['href']

        title_element = job.at_css('h2')
        company_name =  job.at_css('h2 + p').text
        hash[:title] = title_element.text + ' | ' + company_name
        jobs << hash

        misc = job.css('div')[5]
        hash[:misc] = misc.text.strip.gsub("\n", " ")
      end
      all_jobs = all_jobs + jobs
    end
    all_jobs
  end

  private

  def get_scrap_url(page_num)
    url = base_url + @scrap_path
    return url if page_num == 1
    url + "?page=#{page_num}"
  end
end
