Redmine gitolite script
=======================


This script consumes redmine group membership from the redmine api and 
generates gitolite configs.


Depenencies
===========

Requires perl, WWW::Curl::Easy, YAML, JSON. Makefile.pl(or 
equivalent) coming soon

Usage
=====

Copy the config.yaml.example to config.yaml and tune to your needs

Create a redmine api key by following the instructions [here](http://www.redmine.org/projects/redmine/wiki/Rest_api "Redmine API Documentation")

The script will print to standard out (write to file coming soon)

    ./gitolite-remine.pl > gitolite.conf



Tests
=====

There are no tests yet. Coming soon.


License & Copyright
===================

(C) 2013 Spencer Krum for the PSU Computer Action Team

Released under the Apache 2.0 License
