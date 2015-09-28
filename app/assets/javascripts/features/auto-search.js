$(function(){
  var search_sidebar_template = JST['templates/search_sidebar'],

      search_project_template = JST['templates/search/project'],
      search_story_template = JST['templates/search/story'],
      search_task_template = JST['templates/search/task'],
      search_comment_template = JST['templates/search/comment'],
      search_attachment_template = JST['templates/search/attachment'],

      search_xhr, current_search_xhr;

  // clicking outside the search sidebar closes it
  $(document).on("click", function() {
    closeSearchSidebar();
  });
  $(document).on("click", "#search-sidebar", function(ev) {
    ev.stopPropagation();
  });

  // open the sidebar
  $(document).on('click', '.main-menu-item.search', function(ev){
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
      performSearch();
    }
  });

  // do not actually submit the form
  $(document).on('submit', '#search-sidebar form', function(ev){
    ev.preventDefault();
  });

  function openSearchSidebar(){
    $('body').append(search_sidebar_template());
    $('#search-sidebar input').focus();
    // need to give the append a second to add the sidebar
    // or the css transition doesn't work
    setTimeout(function() {
      $('body').addClass('search-sidebar-open');
    }, 10);
  }

  function closeSearchSidebar(){
    $('body').removeClass('search-sidebar-open');
    // using a timeout to allow the css animation to finish
    setTimeout(function() {
      $('#search-sidebar').remove();
    }, 500);
  }

  // does the actual search
  function performSearch(){
    if (current_search_xhr) current_search_xhr.abort();

    $('#search-sidebar').addClass('searching');
    $('#search-sidebar .no-results').hide();
    $('#search-sidebar .search-results').hide();
    $('#search-sidebar .search-results ul').html('');

    var $form = $('#search-sidebar form'),
        term = $form.find('input[name=q]').val();

    if (term.length) {
      search_xhr = $.ajax({
        dataType: "json",
        url: $form.attr('action'),
        method: "GET",
        data: $form.serialize()
      });

      current_search_xhr = search_xhr;

      current_search_xhr.done(function(resp){
        if (resp.search.length) {
          $('#search-sidebar .search-results span.count').html(resp.search.length);
          $('#search-sidebar .search-results span.term').html(term);
          $('#search-sidebar .search-results').show();

          _.each(resp.search, function(result){
            addSearchResult(result);
          });

        // no results found
        } else {
          $('#search-sidebar .no-results span').html(term);
          $('#search-sidebar .no-results').show();
        }
      });

      current_search_xhr.fail(function(){
        // failed or aborted
      });

      current_search_xhr.always(function(){
        $('#search-sidebar').removeClass('searching');
      });

    // term field is empty
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