$(function(){
	$('.plot').each(function(index, component) {

		var series = $(component).data('series');
		if(typeof(series) != "object"){
			series = [];
		}

		var ranges = $(component).data('ranges');
		if(typeof(ranges) != "object"){
			ranges = [];
		}

		var functions = $(component).data('functions');
		if(typeof(functions)== "object"){
			functions.forEach(function(entry, plotNr){
				var data = [];
				if(typeof(ranges[plotNr])!="object"){
					ranges[plotNr] = [];
				}
				var min = (typeof(ranges[plotNr][0])!="number")? -1 :ranges[plotNr][0];
				var max = (typeof(ranges[plotNr][1])!="number")?  1 :ranges[plotNr][1];
				
				for (var i = min; i <= max; i += 0.1) {
					var func = new Function("x", "return "+entry);
					data.push([i, func(i)]);
				}
				series.push(data);
			});
		}
		
		var axis_labels = $(component).data('axis');
		var xaxis_label = (typeof(axis_labels) == "object" && typeof(axis_labels[0]) == "string")?axis_labels[0]:"x";
		var yaxis_label = (typeof(axis_labels) == "object" && typeof(axis_labels[1]) == "string")?axis_labels[1]:"f(x)";
		


	    $.plot(component, series, {
		    xaxis: {
	            axisLabel: xaxis_label,
	            axisLabelUseCanvas: true,
	            axisLabelFontFamily: 'Helvetica'
	        },
	        yaxis: {
	            axisLabel: yaxis_label,
	            axisLabelUseCanvas: true,
	            axisLabelFontFamily: 'Helvetica'
	        },
	    	series: {
		        lines: { show: true },
		        points: { show: false }
    		}
	    });
	    //alert("Test:"+$(component).data('series')["data"][1]);
	});
});

(function ($) {
    var options = { };

    function init(plot) {
        // This is kind of a hack. There are no hooks in Flot between
        // the creation and measuring of the ticks (setTicks, measureTickLabels
        // in setupGrid() ) and the drawing of the ticks and plot box
        // (insertAxisLabels in setupGrid() ).
        //
        // Therefore, we use a trick where we run the draw routine twice:
        // the first time to get the tick measurements, so that we can change
        // them, and then have it draw it again.
        var secondPass = false;
        plot.hooks.draw.push(function (plot, ctx) {
            if (!secondPass) {
                // MEASURE AND SET OPTIONS
                $.each(plot.getAxes(), function(axisName, axis) {
                    var opts = axis.options // Flot 0.7
                        || plot.getOptions()[axisName]; // Flot 0.6
                    if (!opts || !opts.axisLabel)
                        return;

                    var w, h;
                    if (opts.axisLabelUseCanvas != false)
                        opts.axisLabelUseCanvas = true;

                    if (opts.axisLabelUseCanvas) {
                        // canvas text
                        if (!opts.axisLabelFontSizePixels)
                            opts.axisLabelFontSizePixels = 14;
                        if (!opts.axisLabelFontFamily)
                            opts.axisLabelFontFamily = 'sans-serif';
                        // since we currently always display x as horiz.
                        // and y as vertical, we only care about the height
                        w = opts.axisLabelFontSizePixels;
                        h = opts.axisLabelFontSizePixels;

                    } else {
                        // HTML text
                        var elem = $('<div class="axisLabels" style="position:absolute;">' + opts.axisLabel + '</div>');
                        plot.getPlaceholder().append(elem);
                        w = elem.outerWidth(true);
                        h = elem.outerHeight(true);
                        elem.remove();
                    }

                    if (axisName.charAt(0) == 'x')
                        axis.labelHeight += h;
                    else
                        axis.labelWidth += w;
                    opts.labelHeight = axis.labelHeight;
                    opts.labelWidth = axis.labelWidth;
                });
                // re-draw with new label widths and heights
                secondPass = true;
                plot.setupGrid();
                plot.draw();


            } else {
                // DRAW
                $.each(plot.getAxes(), function(axisName, axis) {
                    var opts = axis.options // Flot 0.7
                        || plot.getOptions()[axisName]; // Flot 0.6
                    if (!opts || !opts.axisLabel)
                        return;

                    if (opts.axisLabelUseCanvas) {
                        // canvas text
                        var ctx = plot.getCanvas().getContext('2d');
                        ctx.save();
                        ctx.font = opts.axisLabelFontSizePixels + 'px ' +
                                opts.axisLabelFontFamily;
                        var width = ctx.measureText(opts.axisLabel).width;
                        var height = opts.axisLabelFontSizePixels;
                        var x, y;
                        if (axisName.charAt(0) == 'x') {
                            x = plot.getPlotOffset().left + plot.width()/2 - width/2;
                            y = plot.getCanvas().height;
                        } else {
                            x = height * 0.72;
                            y = plot.getPlotOffset().top + plot.height()/2 - width/2;
                        }
                        ctx.translate(x, y);
                        ctx.rotate((axisName.charAt(0) == 'x') ? 0 : -Math.PI/2);
                        ctx.fillText(opts.axisLabel, 0, 0);
                        ctx.restore();

                    } else {
                        // HTML text
                        plot.getPlaceholder().find('#' + axisName + 'Label').remove();
                        var elem = $('<div id="' + axisName + 'Label" " class="axisLabels" style="position:absolute;">' + opts.axisLabel + '</div>');
                        if (axisName.charAt(0) == 'x') {
                            elem.css('left', plot.getPlotOffset().left + plot.width()/2 - elem.outerWidth()/2 + 'px');
                            elem.css('bottom', '0px');
                        } else {
                            elem.css('top', plot.getPlotOffset().top + plot.height()/2 - elem.outerHeight()/2 + 'px');
                            elem.css('left', '0px');
                        }
                        plot.getPlaceholder().append(elem);
                    }
                });
                secondPass = false;
            }
        });
    }



    $.plot.plugins.push({
        init: init,
        options: options,
        name: 'axisLabels',
        version: '1.0'
    });
})(jQuery);