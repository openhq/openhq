angular.module("OpenHq").directive("searchResultStory", function() {
  return {
    restrict: "E",
    scope: {
      result: '=',
    },
    template: JST['templates/directives/search_results/story'],

    controller: function($scope, $rootScope) {
      $scope.closeDialogs = function(){
        $rootScope.$broadcast('dialogs:close');
      }
    }
  }
});