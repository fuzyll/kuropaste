begin
    require "./bundle/bundler/setup"
    require "bundler"
    Bundler.require
rescue LoadError
    require "bundler"
    Bundler.setup
    Bundler.require
end
require File.dirname(__FILE__) + "/kuropaste"

log = File.new("logs/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)
run KuroPaste::Application

