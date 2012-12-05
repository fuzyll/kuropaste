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

Roadmap:
* Add Grit as a dependency and make all pastes into clonable git repositories
* Add a few more things to the database (creation time, unique base52 ID, etc)
* Support Postgres as a backend (should also let user choose a backend)
* Add some unit tests or something so I know when I've broken everything
* Maybe use SASS to handle CSS templates? (might not be worth the effort)

