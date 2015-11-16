angular.module("OpenHq").directive("searchSidebar", function(Search) {
  return {
    restrict: "E",
    template: JST['templates/directives/search_sidebar'],

    controller: function($scope, $rootScope) {
      $scope.searching = false;
      $scope.term = "";
      $scope.count = 0; // number of total results
      $scope.searchResults = [];
      $scope.morePages = false;
      $scope.currentPage = 1;
      $scope.loadingMore = false;
      $scope.searchRequest = null;

      /**
       * Mousetrap open/close the sidebar
       */
      Mousetrap.bind(['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'], function() {
        $scope.openSearchSidebar();
      });
      Mousetrap.bind('esc', function() {
        $rootScope.$broadcast('dialogs:close');
      });

      $scope.stopProp = function($event) {
        $event.stopPropagation();
      };

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
       * Close the sidebar from a broadcast
       */
      $rootScope.$on('dialogs:close', function(){
        $scope.closeSearchSidebar();
      });

      /**
       * Open the sidebar from a broadcast
       */
      $rootScope.$on('search:open', function(){
        $scope.openSearchSidebar();
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
        $scope.searchResults = [];
        $scope.currentPage = 1;

        if ($scope.term == "") {
          $scope.count = 0;
          $scope.morePages = false;
          $scope.searching = false;

        } else {
          $scope.searching = true;
          $scope.loadResults();
        }
      });

      /**
       * Perform the search and render the results etc.
       */
      $scope.loadResults = function() {
        if (_.isObject($scope.searchRequest)) $scope.searchRequest.abort();

        $scope.searchRequest = Search.find($scope.term, { page: $scope.currentPage });
        $scope.searchRequest.then(function(resp){
          $scope.count = resp.meta.total;
          $scope.morePages = resp.meta.has_more;

          resp.search_documents.forEach(function(result){
            $scope.searchResults.push(result);
          });

          $scope.searching = false;
          $scope.loadingMore = false;
        });
      };

      /**
       * Loads the next page of results
       */
      $scope.loadMore = function() {
        if ($scope.loadingMore) return;

        $scope.currentPage++;
        $scope.loadingMore = true;
        $scope.loadResults();
      };

    }
  }
});
