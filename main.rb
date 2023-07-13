require 'debug'
require 'erb'
Dir.new('./scrapers').children.each do |file|
  require_relative "./scrapers/#{file}"
end

gorails = GoRails.new
gorails.scrape_and_generate_page

weworkremotely = WeWorkRemotely.new
weworkremotely.scrape_and_generate_page

rubyonremote = RubyOnRemote.new
rubyonremote.scrape_and_generate_page

rubyonrailsjobs = RubyOnRailsJobs.new
rubyonrailsjobs.scrape_and_generate_page

railshotwirejobs = RailsHotwireJobs.new
railshotwirejobs.scrape_and_generate_page
