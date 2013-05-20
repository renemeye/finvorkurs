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



Documentation
-------------
[more here](./doc/README.md)


Development
-----------

Since Version 1.0.0, we are developing with this branchning model:
* http://nvie.com/posts/a-successful-git-branching-model/

Have a look to GitHub Issues if you want more information.
