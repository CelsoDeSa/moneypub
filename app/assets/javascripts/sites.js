$(function() {
  // $('#loading-indicator').hide();  // hide it initially.
  // $('#searcher2').hide();
  $(document)
      .on("ajaxStart.search", function() {
        $('.jumbotron').remove();
        $('#presentation').remove();
        $('#searcher2').removeClass('hidden');
        $('#search').addClass('linkloading');
        $('#loading-indicator').removeClass('hidden'); // show on any Ajax event.
      })
      .on("ajaxStop.search", function() {
        $('#loading-indicator').addClass('hidden'); // hide it when it is done.
        $('#search').removeClass('linkloading');
    });
});
