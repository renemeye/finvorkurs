$(function(){

    $('.category_vizualisation').each(function(index, component) {
        var data = $(component).data('bars');
        var yaxis_label = $(component).data('yaxis_label');
        $.plot(component ,[data] , {
            series: {
                bars: {
                    show: true,
                    barWidth: 0.6,
                    align: "center"
                }
            },
            xaxis: {
                mode: "categories",
                tickLength: 0
            },
            yaxis: {
                axisLabel: yaxis_label,
                axisLabelUseCanvas: true,
                axisLabelFontFamily: 'Helvetica'
            }
        });
    });

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

/*
Flot plugin for plotting textual data or categories. Consider a
dataset like [["February", 34], ["March", 20], ...]. This plugin
allows you to plot such a dataset directly.

To enable it, you must specify mode: "categories" on the axis with the
textual labels, e.g.

  $.plot("#placeholder", data, { xaxis: { mode: "categories" } });

By default, the labels are ordered as they are met in the data series.
If you need a different ordering, you can specify "categories" on the
axis options and list the categories there:

   xaxis: {
       mode: "categories",
       categories: ["February", "March", "April"]
   }

If you need to customize the distances between the categories, you can
specify "categories" as an object mapping labels to values

   xaxis: {
       mode: "categories",
       categories: { "February": 1, "March": 3, "April": 4 }
   }

If you don't specify all categories, the remaining encountered
categories will be numbered from the max value plus 1 (with a spacing
of 1 between each).


Internally, the plugin works by transforming the input data through an
auto-generated mapping where the first category becomes 0, the second
1, etc. Hence, a point like ["February", 34] becomes [0, 34]
internally in Flot (this is visible in hover and click events that
return numbers rather than the category labels). The plugin also
overrides the tick generator to spit out the categories as ticks
instead of the values.

If you need to map a value back to its label, the mapping is always
accessible as "categories" on the axis object, e.g.
plot.getAxes().xaxis.categories.
*/

(function ($) {
    var options = {
        xaxis: {
            categories: null
        },
        yaxis: {
            categories: null
        }
    };
    
    function processRawData(plot, series, data, datapoints) {
        // if categories are enabled, we need to disable
        // auto-transformation to numbers so the strings are intact
        // for later processing

        var xCategories = series.xaxis.options.mode == "categories",
            yCategories = series.yaxis.options.mode == "categories";
        
        if (!(xCategories || yCategories))
            return;

        var format = datapoints.format;

        if (!format) {
            // FIXME: auto-detection should really not be defined here
            var s = series;
            format = [];
            format.push({ x: true, number: true, required: true });
            format.push({ y: true, number: true, required: true });

            if (s.bars.show || (s.lines.show && s.lines.fill)) {
                format.push({ y: true, number: true, required: false, defaultValue: 0 });
                if (s.bars.horizontal) {
                    delete format[format.length - 1].y;
                    format[format.length - 1].x = true;
                }
            }
            
            datapoints.format = format;
        }

        for (var m = 0; m < format.length; ++m) {
            if (format[m].x && xCategories)
                format[m].number = false;
            
            if (format[m].y && yCategories)
                format[m].number = false;
        }
    }

    function getNextIndex(categories) {
        var index = -1;
        
        for (var v in categories)
            if (categories[v] > index)
                index = categories[v];

        return index + 1;
    }

    function categoriesTickGenerator(axis) {
        var res = [];
        for (var label in axis.categories) {
            var v = axis.categories[label];
            if (v >= axis.min && v <= axis.max)
                res.push([v, label]);
        }

        res.sort(function (a, b) { return a[0] - b[0]; });

        return res;
    }
    
    function setupCategoriesForAxis(series, axis, datapoints) {
        if (series[axis].options.mode != "categories")
            return;
        
        if (!series[axis].categories) {
            // parse options
            var c = {}, o = series[axis].options.categories || {};
            if ($.isArray(o)) {
                for (var i = 0; i < o.length; ++i)
                    c[o[i]] = i;
            }
            else {
                for (var v in o)
                    c[v] = o[v];
            }
            
            series[axis].categories = c;
        }

        // fix ticks
        if (!series[axis].options.ticks)
            series[axis].options.ticks = categoriesTickGenerator;

        transformPointsOnAxis(datapoints, axis, series[axis].categories);
    }
    
    function transformPointsOnAxis(datapoints, axis, categories) {
        // go through the points, transforming them
        var points = datapoints.points,
            ps = datapoints.pointsize,
            format = datapoints.format,
            formatColumn = axis.charAt(0),
            index = getNextIndex(categories);

        for (var i = 0; i < points.length; i += ps) {
            if (points[i] == null)
                continue;
            
            for (var m = 0; m < ps; ++m) {
                var val = points[i + m];

                if (val == null || !format[m][formatColumn])
                    continue;

                if (!(val in categories)) {
                    categories[val] = index;
                    ++index;
                }
                
                points[i + m] = categories[val];
            }
        }
    }

    function processDatapoints(plot, series, datapoints) {
        setupCategoriesForAxis(series, "xaxis", datapoints);
        setupCategoriesForAxis(series, "yaxis", datapoints);
    }

    function init(plot) {
        plot.hooks.processRawData.push(processRawData);
        plot.hooks.processDatapoints.push(processDatapoints);
    }
    
    $.plot.plugins.push({
        init: init,
        options: options,
        name: 'categories',
        version: '1.0'
    });
})(jQuery);