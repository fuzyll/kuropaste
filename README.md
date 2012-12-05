kuropaste
=========

KuroPaste is intended to be a really simple Pastebin clone for use on a
Darknet.

Features:
* Saves pastes into a database (currently hard-coded to a SQLite database)
* Uses Ultraviolet to provide syntax coloring

Dependencies:
* ruby >= 1.9
* bundler

Usage:
    cd /path/to/kuropaste
    bundle install --deployment
    # safely take your box offline
    bundle exec rackup kuropaste.ru

Short-Term Roadmap:
* Create new img/logo.png and img/favicon.ico
* Log more data in the database (creation time, unique base52 paste ID, etc)
* Limit list functionality to 25/50/100 pastes at a time
* Add line number toggle in show functionality
* Add search functionality to top bar
* Continue tweaking CSS styles
* Test setting up Apache and Passenger

Long-Term Roadmap:
* Add some unit tests or something so I know when I've broken everything
* Add support for handling multiple files per paste
* Use Grit as backend and make all pastes into clonable git repositories
* Consider using SASS to handle CSS templates

