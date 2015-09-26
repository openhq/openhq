$(function(){
  var search_sidebar_template = JST['templates/search_sidebar'],
      search_animation_speed = 500,
      search_timeout = false;

  // clicking outside the search sidebar closes it
  $(document).on("click", function() {
    closeSearchSidebar();
  });
  $(document).on("click", "#search-sidebar", function(ev) {
    ev.stopPropagation();
  });

  // open the sidebar
  $(document).on('click', '.ui-dropdown-menu.search', function(ev){
    openSearchSidebar();
  });

  // do the search when typing in the search field
  $(document).on('keyup', '#search-sidebar input[name=q]', function(){
    $('#search-sidebar').addClass('searching');
    clearTimeout(search_timeout);
    search_timeout = setTimeout(function() {
      performSearch();
    }, 500);
  });

  // do not actually submit the form
  $(document).on('submit', '#search-sidebar form', function(ev){
    ev.preventDefault();
  });

  function openSearchSidebar(){
    $('body').append(search_sidebar_template());
    $('#search-sidebar input').focus();
    $('#search-sidebar').animate({right: 0}, search_animation_speed);
  }

  function closeSearchSidebar(){
    $('#search-sidebar').animate({right: '-400px'}, search_animation_speed, function(){
      $('#search-sidebar').remove();
    });
  }

  function performSearch(){
    $form = $('#search-sidebar form');
    $.ajax({
      dataType: "json",
      url: $form.attr('action'),
      method: "GET",
      data: $form.serialize()
    })
    .done(function(resp){
      console.log(resp);
    })
    .fail(function(){
      console.error('something went wrong with the search');
    })
    .always(function(){
      $('#search-sidebar').removeClass('searching');
    });
  }
});