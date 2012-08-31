//= require common/common
//= require ckeditor/init
//= require bootstrap-transition
//= require bootstrap-collapse
//= require bootstrap-tab

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

  $('#form-locale-tabs li:eq(0) a').tab('show');

  $('#form-locale-tabs a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  });
});
