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


Usage of static Random Nr's
---------------------------
In order to present the question-ordering and shown answers randomly, but having a stable bahavior, we are using static-pseudo-random-numbers.

### Pseudocode selecting next Question
	Answerd allready max Numbers? -> end
	Take a Random Question
		--> Answerd this? --> Take Next Question
		--> Ask this 

### Pseudocode selecting Answers
	count_answers = min(Answers.count, max_answers_count)
	count_answers.times do |counter|
		addAnswer(nexr random) if not in
		if last had a correct?
		if last had a wrong? 
	end©