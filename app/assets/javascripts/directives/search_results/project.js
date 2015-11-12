angular.module("OpenHq").directive("searchResultProject", function() {
  return {
    restrict: "E",
    scope: {
      result: '=',
    },
    template: JST['templates/directives/search_results/project'],

    controller: function($scope, $rootScope) {
      $scope.closeDialogs = function(){
        $rootScope.$broadcast('dialogs:close');
      }
    }
  }
});