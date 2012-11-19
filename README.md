kuropaste
=========

KuroPaste is intended to be a really simple Pastebin clone for use on a
Darknet.

Depencencies:
* Sinatra (and, by extension, WEBrick)
* HAML
* Sequel
* Ultraviolet

Features:
* Saves pastes into a database (currently hard-coded to a SQLite database)
* Uses Ultraviolet to provide syntax coloring

Roadmap:
* Add Grit as a dependency and make all pastes into clonable git repositories
* Add a few more things to the database (creation time, unique base52 ID, etc)
* Support Postgres as a backend (should also let user choose a backend)
* Add some unit tests or something so I know when I've broken everything
* Make the default HAML layout not look like complete trash
* Maybe use SASS to handle CSS templates? (might not be worth the effort)

