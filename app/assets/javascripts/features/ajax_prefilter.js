App.onPageLoad(function() {
  // Reset CSRF token for ajax requests on each page load
  var token = $("meta[name='csrf-token']").attr("content");

  $.ajaxPrefilter(function (options, originalOptions, jqXHR) {
    jqXHR.setRequestHeader('X-CSRF-Token', token);
  });
});
