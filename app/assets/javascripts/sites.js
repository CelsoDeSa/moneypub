$(function() {
  $('#loading-indicator').hide();  // hide it initially.
  $(document)  
    .ajaxStart(function() {
      $('#search').remove();
      $('#loading-indicator').show(); // show on any Ajax event.
    })
    .ajaxStop(function() {
      $('#loading-indicator').hide(); // hide it when it is done.
  });
});