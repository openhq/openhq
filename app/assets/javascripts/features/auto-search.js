$(function(){
  var search_sidebar_template = JST['templates/search_sidebar'],

      search_project_template = JST['templates/search/project'],
      search_story_template = JST['templates/search/story'],
      search_task_template = JST['templates/search/task'],
      search_comment_template = JST['templates/search/comment'],
      search_attachment_template = JST['templates/search/attachment'],

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
  $(document).on('search:open', function(){
    openSearchSidebar();
  });

  // pressing esc key
  $(document).on('dialogs:close', function(){
    closeSearchSidebar();
  });

  // do the search when typing in the search field
  $(document).on('keyup', '#search-sidebar input[name=q]', function(ev){
    // esc key
    if (ev.keyCode == 27) {
      closeSearchSidebar();

    } else {
      $('#search-sidebar').addClass('searching');
      $('#search-sidebar .no-results').hide();
      $('#search-sidebar .search-results').hide();
      $('#search-sidebar .search-results ul').html('');

      clearTimeout(search_timeout);
      search_timeout = setTimeout(function() {
        performSearch();
      }, 500);
    }
  });

  // do not actually submit the form
  $(document).on('submit', '#search-sidebar form', function(ev){
    ev.preventDefault();
  });

  function openSearchSidebar(){
    $('body').addClass('search-sidebar-open');
    $('body').append(search_sidebar_template());
    $('#search-sidebar input').focus();
    $('#search-sidebar').animate({right: 0}, search_animation_speed);
  }

  function closeSearchSidebar(){
    $('body').removeClass('search-sidebar-open');
    $('#search-sidebar').animate({right: '-400px'}, search_animation_speed, function(){
      $('#search-sidebar').remove();
    });
  }

  // does the actual search
  function performSearch(){
    var $form = $('#search-sidebar form'),
        term = $form.find('input[name=q]').val();

    if (term.length) {
      $.ajax({
        dataType: "json",
        url: $form.attr('action'),
        method: "GET",
        data: $form.serialize()
      })

      .done(function(resp){
        if (resp.search.length) {
          $('#search-sidebar .search-results span.count').html(resp.search.length);
          $('#search-sidebar .search-results span.term').html(term);
          $('#search-sidebar .search-results').show();

          _.each(resp.search, function(result){
            addSearchResult(result);
          });

        } else {
          $('#search-sidebar .no-results span').html(term);
          $('#search-sidebar .no-results').show();
        }
      })

      .fail(function(){
        console.error('something went wrong with the search');
      })

      .always(function(){
        $('#search-sidebar').removeClass('searching');
      });
    } else {
      $('#search-sidebar').removeClass('searching');
      $('#search-sidebar .no-results').hide();
      $('#search-sidebar .search-results').hide();
    }
  }

  // generates the html and adds it to the search results
  function addSearchResult(result) {
    var result_html;

    switch(result.searchable_type) {
      case "Project":
      result_html = search_project_template({ result: result });
      break;

      case "Story":
      result_html = search_story_template({ result: result });
      break;

      case "Task":
      result_html = search_task_template({ result: result });
      break;

      case "Comment":
      result_html = search_comment_template({ result: result });
      break;

      case "Attachment":
      result_html = search_attachment_template({ result: result });
      break;
    }

    $('#search-sidebar .search-results ul').append("<li>"+result_html+"</li>");
  }
});