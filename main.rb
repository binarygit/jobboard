require 'debug'
require 'erb'
Dir.new('./scrapers').children.each do |file|
  require_relative "./scrapers/#{file}"
end
