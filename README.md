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
```
    cd /path/to/kuropaste
    bundle install --deployment
    # safely take your box offline
    bundle exec rackup config.ru
```

Short-Term Roadmap:
* Change primary keys in database from incrementing integers to unique base52
  IDs (these will be used as repository names after switching to Grit-backed
  pastes)
* Paginate list functionality
* Test setting up Apache and Passenger

Long-Term Roadmap:
* Add some unit tests or something so I know when I've broken everything
* Add support for handling multiple files per paste
* Use Grit as backend and make all pastes into clonable git repositories
* Consider using SASS to handle CSS templates

