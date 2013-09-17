$(function() {

     var slide_and_times = [];

     setTimeout(function(){
          var player = videojs("vjs_video_4_html5_api");
          var show

          var timeupdate = function(){
                //check if slides should have changed
                var myPlayer = this;
                var time_of_playing = myPlayer.currentTime();
                var actual_slide = get_slide_by_time(time_of_playing);

                if(actual_slide || actual_slide === 0){
                    $('#slidescarousel').carousel(actual_slide);
                    $('#slide-id').html(actual_slide);     
                }

               $('#time').html(time_of_playing);
          }

          var slide = function(){
               player.off("timeupdate", timeupdate);
          }
          var slid = function(){
               player.on("timeupdate", timeupdate);
          }

          $('#slidescarousel').on('slide', slide);
          $('#slidescarousel').on('slid', slid);

          //Here the change of slides and timer happens
          player.on("timeupdate", timeupdate);
          
     }, 4000);


     //Initialize by reading all the data-start-time attributes from the slides
     $(".one-slide").each(function(index,slide){
          slide_and_times.push([parseFloat($(slide).data("start-time")),index])
     });

     $('#slidescarousel').carousel({
       interval: false
     });

     function get_slide_by_time(time){
          actual_slide = false;
          slide_and_times.forEach(function(slide) {
               if(time > slide[0]){
                    actual_slide = slide[1];
               }
          });
          return actual_slide;
     }


});


//TODO store last position. --> In Case of reload 