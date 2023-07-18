#!/usr/bin/ruby
require 'webrick'
require 'debug'

root = File.expand_path '/home/kali/Documents/jobboard/'
log_file = File.open '/home/kali/Documents/jobboard/production.log', 'a+'
log = WEBrick::Log.new log_file
access_log = [
      [log_file, WEBrick::AccessLog::COMBINED_LOG_FORMAT],
]

server = WEBrick::HTTPServer.new :Port => 80, :DocumentRoot => root

trap 'INT' do server.shutdown end

WEBrick::Daemon.start
server.start
