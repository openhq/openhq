$(function() {
  if ( ! App.isTouchDevice()) return;

  var $menu = $(".app-header");

  var hammertime = new Hammer($menu.get(0), {});

  hammertime.on('swipe', function(ev) {
    console.log(ev);

    if ($menu.hasClass("open")) return;

    $menu.addClass("open");
  });

  $(document).on("click", ".app-header .close-cross", function() {
    $menu.removeClass("open");
  });

  // $(document).on("click", ".app-header a", function() {
  //   App.slideout.close();
  // });

  // App.slideout = new Slideout({
  //   'panel': $('#panel').get(0),
  //   'menu': $('#main-nav').get(0),
  //   'padding': 380,
  //   'tolerance': 70,
  //   'side': 'right'
  // });

  // _.defer(function() {
  //   App.onPageLoad(function() {
  //     App.slideout._initTouchEvents();
  //   });
  // });

});
