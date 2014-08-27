$(function() {
  $('#loading-indicator').hide();  // hide it initially.
  $('#searcher2').hide();
  $(document)  
    .ajaxStart(function() {
      $('#search').remove();
      $('.jumbotron').remove();
      $('#searcher2').show();
      $('#loading-indicator').show(); // show on any Ajax event.
    })
    .ajaxStop(function() {
      $('#loading-indicator').hide(); // hide it when it is done.
  });
});