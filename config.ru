Bundler.setup
Bundler.require

require "./kuropaste"

log = File.new("logs/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)
run KuroPaste::Application

