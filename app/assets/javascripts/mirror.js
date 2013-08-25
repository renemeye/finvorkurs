$(function(){
	$(".mirror").each(function(index, comp){
		var mirror_id=$(comp).data("mirror");
		var mirrored_data = $("#"+mirror_id).html();
		//$(mirrored_data)
		try{
			if($(mirrored_data).hasClass("plot")){
				mirrored_data=$(mirrored_data).html("");
			}
		}catch(err){}
		$(comp).html(mirrored_data);
		$(comp).find(".plot").each(redraw_plot);
	});
})