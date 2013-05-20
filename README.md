[![Build Status](https://travis-ci.org/FIN-Vorkurs/finvorkurs.png)](https://travis-ci.org/FIN-Vorkurs/finvorkurs)

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
6. ```rails s```

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
6. ```foreman start -f Procfile.development```



Documentation
-------------
[more here](./doc/README.md)


Development
-----------

Since Version 1.0.0, we are developing with this branchning model:
* http://nvie.com/posts/a-successful-git-branching-model/

Have a look to GitHub Issues if you want more information.
