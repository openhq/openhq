angular.module("OpenHq").directive("searchSidebar", function(Search) {
  return {
    restrict: "E",
    scope: {
      task: '=',
      users: '=',
    },
    template: JST['templates/directives/search_sidebar'],
    controller: function($scope) {
      $scope.searching = false; // currently performing a seach
      $scope.term = ""; // what the user has searched for
      $scope.count = 0; // number of results returned
      $scope.morePages = false; // the search results include more pages
      $scope.page = 1; // current page of results

      // Result templates
      $scope.project_template = JST['templates/search/project'];
      $scope.story_template = JST['templates/search/story'];
      $scope.task_template = JST['templates/search/task'];
      $scope.comment_template = JST['templates/search/comment'];
      $scope.attachment_template = JST['templates/search/attachment'];

      // Mousetrap open/close the sidebar
      Mousetrap.bind(['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'], function() {
        $scope.openSearchSidebar();
      });
      Mousetrap.bind('esc', function() {
        $scope.closeSearchSidebar();
      });

      // clicking outside the search sidebar closes it
      $(document).on("click", function() {
        $scope.closeSearchSidebar();
      });
      $(document).on("click", "search-sidebar", function(ev) {
        ev.stopPropagation();
      });

      $scope.openSearchSidebar = function() {
        $('search-sidebar input').focus();
        $('body').addClass('search-sidebar-open');
      };
      $scope.closeSearchSidebar = function() {
        $('body').removeClass('search-sidebar-open');
        setTimeout(function() {
          $('search-sidebar input').val('');
        }, 500);
      };

      $scope.$watch('term', function() {
        if ($scope.term == "") {
          $scope.count = 0;
          $scope.morePages = false;
          $scope.searching = false;
          $scope.page = 1;

        } else {
          $scope.performSearch();
        }
      });

      $scope.performSearch = function() {
        $scope.searching = true;

        Search.query({ term: $scope.term }).then(function(resp){
          console.log(resp);
          $scope.count = resp.meta.total;
          $scope.morePages = resp.meta.has_more;
          $scope.page = 1;

          $scope.renderResults(resp.search_documents);

          $scope.searching = false;
        });
      };

      $scope.renderResults = function(results, opts) {
        var $results_list = $('search-sidebar .ui-search-list'),
            html = "";

        opts = opts || {};
        _.defaults(opts, {
          fresh: true // clear old results before adding new ones
        });

        console.log(opts);

        if (opts.fresh) $results_list.html('');

        _.each(results, function(result){
          html += $scope.renderResult(result);
        });

        $results_list.append(html);
      };

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
