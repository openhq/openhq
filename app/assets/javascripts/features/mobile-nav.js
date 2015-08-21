$(function() {

  App.onPageLoad(function() {
    if ( ! App.isTouchDevice()) return;

    var $menu = $(".app-header");

    var hammertime = new Hammer($menu.get(0), {
      threshold: 3,
      direction: 'swipeleft'
    });

    hammertime.on('swipe', function(ev) {
      console.log(ev);

      if ($menu.hasClass("open")) return;

      $menu.addClass("open");
    });
  });

  $(document).on("click", ".app-header", function() {
    $(".app-header").addClass("open");
  });

  $(document).on("click", ".app-header .close-cross", function(ev) {
    ev.stopPropagation();

    $(".app-header").removeClass("open");
  });

});
