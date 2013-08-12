// check if an element exists in array using a comparer function
// comparer : function(currentElement)
Array.prototype.inArray = function(element) { 
    if(this.indexOf(element)>-1) return true; 
    return false; 
}; 

// adds an element to the array if it does not already exist using a comparer 
// function
Array.prototype.pushIfNotExist = function(element) { 
    if (!this.inArray(element)) {
        this.push(element);
    }
}; 

Array.prototype.popIfExist = function(element) { 
	var index = this.indexOf(element);
	if(index > -1){
		this.splice(index, 1);
	}
}; 

$(function() {

	//initialize stuff
	$(".mapping > .from").addClass("top");
	$(".mapping > .to").addClass("bottom");
	$(".mapping > .from > div").addClass("btn");
	$(".mapping > .to > div").addClass("btn");

	//Make upper buttons draggable
$( ".mapping .top .btn" ).draggable({
	revert : function(event, ui) {
        $(this).data("uiDraggable").originalPosition = {
            top : 0,
            top : 0
        };
        return !event;
    },
	cursor: "move"
});

//Make lower buttons droppable
$( ".mapping .bottom .btn" ).droppable({
  hoverClass: "active",
  drop: function( event, ui ) {
  	var droppable = $(this);
  	var draggable = ui.draggable;
  	var elements = droppable.data("elements");

  	//initalizer
  	if(typeof(elements) != "object"){
  		elements = [];
  		droppable.data("elements", elements);
  	}

  	//Store which draggable is where
  	elements.pushIfNotExist(draggable.attr("id"));

  	//Coloring & Checkbox-checking
  	if(elements.length === 1){
	    $( this ).addClass( "btn-info" );
	    $(".answers ."+elements[0]+"-"+droppable.attr("id")).prop('checked', true);
	}

    if(elements.length > 1){
        $( this )
          .removeClass( "btn-info" )
          .addClass( "btn-warning" )
        ;
        $(".answers ."+droppable.attr("id")).prop('checked', false);
    }
  },

  out: function( event, ui ) {
  	var droppable = $(this);
  	var draggable = ui.draggable;
  	var elements = droppable.data("elements");

  	//initalizer
  	if(typeof(elements) != "object"){
  		elements = [];
  		droppable.data("elements", elements);
  	}

  	//Store which draggable is where
  	elements.popIfExist(draggable.attr("id"));

	//Coloring & Checkbox-checking
  	if(elements.length === 0){
        $( this )
          .removeClass( "btn-info" )
        ;

        $(".answers ."+droppable.attr("id")).prop('checked', false);
    }
    if(elements.length === 1){
        $( this )
          .addClass( "btn-info" )
          .removeClass( "btn-warning" )
        ;
        $(".answers ."+elements[0]+"-"+droppable.attr("id")).prop('checked', true);
    }
  }
});
});