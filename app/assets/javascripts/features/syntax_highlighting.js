App.onPageLoad(function() {
  $('pre code').each(function(i, block) {
    // Add language class for compatibility
    // with highlight.js
    var lang = $(this).parent().attr("lang");
    $(this).addClass("language-"+ lang);

    hljs.highlightBlock(block);
  });
});
