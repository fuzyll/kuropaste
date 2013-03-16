# include necessary dependencies (try local first, then system-wide)
begin
    require "./bundle/bundler/setup"
    require "bundler"
    Bundler.require
rescue LoadError
    require "bundler"
    Bundler.setup
    Bundler.require
end

# include our application
require "./kuropaste"

# set up logging
log = File.new("logs/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

# run our application
run KuroPaste::Application

