//= require common/common
//= require ckeditor/init
//= require bootstrap-collapse

$(document).ready(function() {
  $('#save-and-new').click(function(event){
    event.preventDefault();
    $('#after_save_redirect').val('new');
    $(this).closest('form').submit();
  });
  $('#save').click(function(event){
    event.preventDefault();
    $('#after_save_redirect').val('default');
    $(this).closest('form').submit();
  });
});
