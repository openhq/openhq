angular.module("OpenHq").directive("searchSidebar", function(Search) {
  return {
    restrict: "E",
    template: JST['templates/directives/search_sidebar'],

    controller: function($scope) {
      $scope.searching = false;
      $scope.term = "";
      $scope.count = 0; // number of total results
      $scope.morePages = false;
      $scope.currentPage = 0;
      $scope.loadingMore = false;

      // Result templates
      $scope.project_template = JST['templates/search/project'];
      $scope.story_template = JST['templates/search/story'];
      $scope.task_template = JST['templates/search/task'];
      $scope.comment_template = JST['templates/search/comment'];
      $scope.attachment_template = JST['templates/search/attachment'];

      /**
       * Mousetrap open/close the sidebar
       */
      Mousetrap.bind(['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'], function() {
        $scope.openSearchSidebar();
      });
      Mousetrap.bind('esc', function() {
        $scope.closeSearchSidebar();
      });

      /**
       * Clicking outside the search sidebar closes it
       */
      $(document).on("click", function() {
        $scope.closeSearchSidebar();
      });
      $(document).on("click", "search-sidebar", function(ev) {
        ev.stopPropagation();
      });

      /**
       * Pressing ESC while in the search sidebar input closes it
       */
      $(document).on('keyup', 'search-sidebar input', function(ev){
        if (ev.keyCode == 27) {
          $('search-sidebar input').blur();
          $scope.closeSearchSidebar();
        }
      });

      /**
       * Clicking a link in the sidebar closes it
       */
      $(document).on('click', 'search-sidebar li a', function(){
        $scope.closeSearchSidebar();
      });

      /**
       * Open the search sidebar
       */
      $scope.openSearchSidebar = function() {
        $('body').addClass('search-sidebar-open');
        $('search-sidebar input').focus();
      };

      /**
       * Close the search sidebar
       */
      $scope.closeSearchSidebar = function() {
        $('body').removeClass('search-sidebar-open');
        $scope.$apply(function(){
          $scope.term = "";
        });
      };

      /**
       * When the search term changes
       */
      $scope.termChanged = function() {
        if ($scope.term == "") {
          $scope.count = 0;
          $scope.morePages = false;
          $scope.searching = false;
          $scope.currentPage = 1;

        } else {
          $scope.performSearch();
        }
      };

      /**
       * Perform the search and render the results etc.
       */
      $scope.performSearch = function() {
        $scope.searching = true;

        Search.query({ term: $scope.term }).then(function(resp){
          $scope.count = resp.meta.total;
          $scope.morePages = resp.meta.has_more;
          $scope.currentPage = 1;

          $scope.renderResults(resp.search_documents);

          $scope.searching = false;
        });
      };

      /**
       * Loads the next page of results
       */
      $scope.loadMore = function() {
        if ($scope.loadingMore) return;

        $scope.currentPage += 1;
        $scope.loadingMore = true;

        Search.query({ term: $scope.term, page: $scope.currentPage }).then(function(resp){
          $scope.count = resp.meta.total;
          $scope.morePages = resp.meta.has_more;

          $scope.renderResults(resp.search_documents, { fresh: false });

          $scope.loadingMore = false;
        });
      };

      /**
       * Renders the results returned from the API in the sidebar
       *
       * @param  Array results
       * @param  Object opts
       */
      $scope.renderResults = function(results, opts) {
        var $results_list = $('search-sidebar .ui-search-list'),
            html = "";

        opts = opts || {};
        _.defaults(opts, {
          fresh: true // clear old results before adding new ones
        });

        if (opts.fresh) $results_list.html('');

        _.each(results, function(result){
          html += $scope.renderResult(result);
        });

        $results_list.append(html);
      };

      /**
       * Gets the HTML for a single search result
       *
       * @param  Object result
       * @return String
       */
      $scope.renderResult = function(result) {
        switch(result.searchable_type) {
          case "Project":
            return $scope.project_template({ result: result });
          case "Story":
            return $scope.story_template({ result: result });
          case "Task":
            return $scope.task_template({ result: result });
          case "Comment":
            return $scope.comment_template({ result: result });
          case "Attachment":
            return $scope.attachment_template({ result: result });
          default:
            console.error('could not render result type:', result.searchable_type);
        }
      }
    }
  }
});
