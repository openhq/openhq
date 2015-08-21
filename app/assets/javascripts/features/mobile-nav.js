$(function() {
  var slideout;

  if ( ! App.isTouchDevice()) return;

  $(document).on("click", ".app-header .close-cross", function() {
    slideout.close();
  });

  App.onPageLoad(function() {
    slideout = new Slideout({
      'panel': document.getElementById('panel'),
      'menu': document.getElementById('main-nav'),
      'padding': 350,
      'tolerance': 70,
      'side': 'right'
    });
  });
});
