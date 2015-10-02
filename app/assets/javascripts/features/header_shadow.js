$(function(){
  $(document).ready(function(){
    setHeaderShadow();
  });
  $(window).on('scroll', function(){
    setHeaderShadow();
  });

  function setHeaderShadow(){
    if ($(document).scrollTop() > 20) {
      $('header.app-header').addClass('shadow');
    } else {
      $('header.app-header').removeClass('shadow');
    }
  }
});