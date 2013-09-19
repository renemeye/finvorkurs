[![Build Status](https://travis-ci.org/renemeye/finvorkurs.png)](https://travis-ci.org/renemeye/finvorkurs)

FIN-Vorkurs
===========

Getting started - **The simple way**
-------------------------------------

1. ```git clone git://github.com/renemeye/finvorkurs.git```
2. ```cd finvorkurs```
3. ``` bundle ```
4. Install [redis](http://redis.io) Server
	* On MacOS:
		```
		foo$ brew install redis
		```
5. start redis
		```
		foo$ redis-server
		```
6. Initialise Database
	* Create DB: ```$ rake db:create```
	* Migrate to current layout: ```$ rake db:migrate```
	* Create initialial admin-user ```$ rake admin:create```
		* Follow Instructions
7. Start Server: ```rails s```
	* Website now running on: http://localhost:3000

Getting started - **The recomended way**
-----------------------------------------

1. ```git clone git://github.com/renemeye/finvorkurs.git```
2. ```cd finvorkurs```
3. ``` bundle ```
4. Install [redis](http://redis.io) Server
	* On MacOS:
		```
		foo$ brew install redis
		```
5. Install [forman](https://github.com/ddollar/foreman)
6. Initialise Database
	* Create DB: ```$ rake db:create```
	* Migrate to current layout: ```$ rake db:migrate```
	* Create initialial admin-user ```$ rake admin:create```
		* Follow Instructions
7. ```foreman start -f Procfile.development```
	* Website now running on: http://localhost:3000
	* Visit-Counter now running on: http://localhost:4242

Working with test driven development
------------------------------------

1. Have a look at this [blog](http://www.ksylvest.com/posts/2012-03-09/faster-testing-in-rails-with-guard-for-zeus-rspec-and-cucumber)
2. ```zeus start```
3. In new Terminal:
	- ```bundle exec guard```


Run on Server
-------------
* If all is Downloaded, Setup and Cofigured:
* Start production (might be in a screen or in an init.d file)
  * ```foreman start -f Procfile -e .env```

* If running on a Apache add the following to public/assets/.htaccess
	AddType video/ogg .ogv
	AddType video/mp4 .mp4
	AddType video/webm .webm

	AddType audio/mpeg .mp3
	AddType audio/ogg .ogg
	AddType audio/mp4 .m4a
	AddType audio/wav /wav

Configuration
-------------
Config entries are compiled from:

    config/settings.yml
    config/settings/#{environment}.yml
    config/environments/#{environment}.yml
    
    config/settings.local.yml
    config/settings/#{environment}.local.yml
    config/environments/#{environment}.local.yml    

Settings defined in files that are lower in the list override settings higher.
**It is highly recommended** to copy one of the existing *.yml files and store your settings in the equivalent *.local.yml

Documentation
-------------
[more here](./doc/README.md)


Development
-----------

Since Version 1.0.0, we are developing with this branchning model:
* http://nvie.com/posts/a-successful-git-branching-model/

Have a look to GitHub Issues if you want more information.
