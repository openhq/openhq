angular.module("OpenHq").directive("searchSidebar", function(Search) {
  return {
    restrict: "E",
    template: JST['templates/directives/search_sidebar'],

    controller: function($scope) {
      $scope.searching = false;
      $scope.term = "";
      $scope.count = 0; // number of total results
      $scope.searchResults = [];
      $scope.morePages = false;
      $scope.currentPage = 0;
      $scope.loadingMore = false;

      /**
       * Mousetrap open/close the sidebar
       */
      Mousetrap.bind(['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'], function() {
        $scope.openSearchSidebar();
      });
      Mousetrap.bind('esc', function() {
        $scope.$apply($scope.closeSearchSidebar);
      });

      /**
       * Clicking outside the search sidebar closes it
       */
      $(document).on("click", function() {
        $scope.$apply($scope.closeSearchSidebar);
      });
      $(document).on("click", "search-sidebar", function(ev) {
        ev.stopPropagation();
      });

      /**
       * Pressing ESC while in the search sidebar input closes it
       */
      $scope.termKeypress = function(ev) {
        if (ev.keyCode == 27) {
          $('search-sidebar input').blur();
          $scope.closeSearchSidebar();
        }
      };

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
        $scope.term = "";
      };

      /**
       * When the search term changes
       */
      $scope.$watch('term', function() {
        if ($scope.term == "") {
          $scope.count = 0;
          $scope.morePages = false;
          $scope.searching = false;
          $scope.currentPage = 1;

        } else {
          $scope.performSearch();
        }
      });

      /**
       * Perform the search and render the results etc.
       */
      $scope.performSearch = function() {
        $scope.searching = true;

        Search.query({ term: $scope.term }).then(function(resp){
          $scope.count = resp.meta.total;
          $scope.morePages = resp.meta.has_more;
          $scope.currentPage = 1;

          $scope.searchResults = resp.search_documents;

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

          // merge the new results into the existing ones
          $scope.searchResults = _.union($scope.searchResults, resp.search_documents);

          $scope.loadingMore = false;
        });
      };

    }
  }
});
