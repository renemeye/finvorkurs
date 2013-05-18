Dokumentation
=============

ER-Diagram
----------
[See ER-Diagram here](./ER-Diagram.pdf)
	
* We used [ERD-Rails](http://rails-erd.rubyforge.org)
* Steps to create a new one
	1. Install graphviz
	2. Generate ER-Diagram: ```$ rake erd```
	3. Move to doc folder: ```$ mv erd.pdf doc/ER-Diagram.pdf```


Generated APP-Documentation
----------------------------
[See Documentation here](./app/index.html)
* Auto-Generated
* Steps to re-create
	1. ```$ rake doc:app```
