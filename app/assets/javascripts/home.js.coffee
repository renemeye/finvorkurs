# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('#user_degree_program_ids').chosen()

	$('.level_checkbox').change (a) ->
		level_id = $(this).attr('id')
		if this.checked
			$('.'+level_id+' input').prop('disabled',false);
			$('.'+level_id+' label').css('color',"black");
		else
			$('.'+level_id+' input').prop('disabled',true);
			$('.'+level_id+' label').css('color',"#ccc");


	$('.level_checkbox').each (a) ->
		level_id = $(this).attr('id')
		if this.checked
			$('.'+level_id+' input').prop('disabled',false);
			$('.'+level_id+' label').css('color',"black");
		else
			$('.'+level_id+' input').prop('disabled',true);
			$('.'+level_id+' label').css('color',"#ccc");