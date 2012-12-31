# kuropaste #

KuroPaste is intended to be a really simple Pastebin clone for use on a
Darknet.

Features:
* Saves pastes into a database (currently hard-coded to a SQLite database)
* Uses Ultraviolet to provide syntax coloring

Dependencies:
* ruby >= 1.9
* bundler

## Installation ##

**NOTE:** This quick guide assumes you are using a Debian-based distribution
          (specifically Debian Wheezy or Ubuntu 12.04).  If you are not, please
          remember to find equivalent commands for your environment.

If you just want to run KuroPaste standalone without a web server, it should
be as easy as doing:

```
sudo apt-get install ruby1.9.1
sudo gem install bundler
git clone git://github.com/fuzyll/kuropaste.git
cd kuropaste
bundle install --standalone
# safely take your box offline or move the directory to another box
bundle exec rackup config.ru
```

**NOTE:** KuroPaste uses a few extensions that are native, so please be sure to
          run `bundle install --standalone` on a box with an equivalent libc if
          you are planning to move the installation to a darknet.

If you want to run KuroPaste with Apache and Passenger, here's how I did it:

```
sudo apt-get install build-essential ruby1.9.1 ruby1.9.1-dev zlib1g-dev \
    libxml2-dev libxslt1-dev apache2 apache2-prefork-dev \
    libcurl4-openssl-dev libapr1-dev libaprutil1-dev
sudo gem1.9.1 install bundler passenger
cd /var/www
git clone git://github.com/fuzyll/kuropaste.git
cd kuropaste
bundle install --standalone
# safely take your box offline or move the directory to another box
sudo passenger-install-apache2-module
echo "LoadModule passenger_module /var/lib/gems/1.9.1/gems/passenger-3.0.18/ext/apache2/mod_passenger.so" | sudo tee /etc/apache2/mods-available/passenger.load
echo -e "PassengerRoot /var/lib/gems/1.9.1/gems/passenger-3.0.18\nPassengerRuby /usr/bin/ruby1.9.1" | sudo tee /etc/apache2/mods-available/passenger.conf
sudo a2enmod passenger
sudo cat > /etc/apache2/sites-available/kuropaste <<EOF
<VirtualHost *:80>
    ServerName kuropaste
    ServerAlias kuropaste.lan  
    DocumentRoot /var/www/kuropaste/content

    <Directory /var/www/kuropaste/content>
            Order allow,deny
            Allow from all
            AllowOverride All
            Options -MultiViews
    </Directory>
</VirtualHost>
EOF
sudo a2dissite default
sudo a2ensite kuropaste
sudo service apache2 restart
```

## Roadmap ##
Short-Term:
* Change primary keys in database from incrementing integers to unique base52
  IDs (these will be used as repository names after switching to Grit-backed
  pastes)
* Paginate list and search functionality

Long-Term:
* Add some unit tests or something so I know when I've broken everything
* Add support for handling multiple files per paste
* Use Grit as backend and make all pastes into clonable git repositories
* Consider using SASS to handle CSS templates

