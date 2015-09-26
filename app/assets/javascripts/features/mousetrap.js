$(function(){
  Mousetrap.bind(['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'], function() {
    $(document).trigger('search:open');
  });
  Mousetrap.bind('esc', function(ev) {
    ev.preventDefault();
    $(document).trigger('dialogs:close');
    console.log('triggered close');
  });
});