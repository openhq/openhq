$(function() {
  $(document).on("click", ".app-header .close-cross", function() {
    App.slideout.close();
  });

  App.onPageLoad(function() {
    App.slideout = new Slideout({
      'panel': document.getElementById('panel'),
      'menu': document.getElementById('main-nav'),
      'padding': 380,
      'tolerance': 70,
      'side': 'right'
    });
  });
});
