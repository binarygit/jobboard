require 'nokogiri'
require 'open-uri'
require 'debug'

base_url = 'https://jobs.gorails.com'
doc = Nokogiri::HTML( URI.open(base_url) ) 
job_postings = doc.css('body > div li')
job_urls = []
titles = []
job_postings.each do |job|
  anchor_tag = job.at_css('a')
  job_urls << base_url + anchor_tag['href']

  title_element = job.at_css('h3')
  titles << title_element.text
end

p job_urls
p titles
