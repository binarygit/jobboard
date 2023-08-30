#!/usr/bin/ruby
require 'webrick'
require 'debug'

root = File.expand_path '/home/kali/Documents/jobboard/'
log_file = File.open '/home/kali/Documents/jobboard/production.log', 'a+'
log = WEBrick::Log.new log_file
access_log = [
      [log_file, WEBrick::AccessLog::COMBINED_LOG_FORMAT],
]

log_analytics = proc do |req|
  file = File.open('analytics', 'a+')
  file << "#{Time.now.utc},#{req.path}\n"
  file.close
end

server = WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => root, :RequestCallback => log_analytics)

trap 'INT' do server.shutdown end

WEBrick::Daemon.start
