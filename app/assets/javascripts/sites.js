$(function() {
  $('#loading-indicator').hide();  // hide it initially.
  $('#searcher2').hide();
  $(document)
      .on("ajaxStart.search", function() {
        $('.jumbotron').remove();
        $('#presentation').remove();
        $('#searcher2').show();
        $('#loading-indicator').show(); // show on any Ajax event.
      })
      .on("ajaxStop.search", function() {
        $('#loading-indicator').hide(); // hide it when it is done.
    });
});
