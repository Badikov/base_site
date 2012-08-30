//= require jquery-1.7.2.min
//= require jquery_ujs
//= require jquery-ui-core-1.8.16.min

//= require rails_validations

//= require bootstrap-alert

$(document).ready(function() {
  
  if($(".fix-on-scroll").length > 0){
    function processScroll() {
      var scrollTop = $win.scrollTop();
      $(".fix-on-scroll").each(function(i, el){
        var startFixed = $(el).data("offset");
        if (scrollTop >= startFixed) {
          $(el).addClass('fixed');
        } else if (scrollTop < startFixed) {
          $(el).removeClass('fixed');
        }
      });
    }
    var $win = $(window);
    processScroll();
    $win.on('scroll', processScroll);
  }
  
  $('#alerts .alert').live('closed', function () {
    $('#alerts').find('.' + $(this).attr('class').replace('alert ', '')).remove();
  });
});

function show_alert(content){
  $("#alerts .back").html($(content));
  $("#alerts .fixed").html($(content));
}