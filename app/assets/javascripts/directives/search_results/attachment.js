angular.module("OpenHq").directive("searchResultAttachment", function() {
  return {
    restrict: "E",
    scope: {
      result: '=',
    },
    template: JST['templates/directives/search_results/attachment'],

    controller: function($scope, $rootScope) {
      $scope.closeDialogs = function(){
        $rootScope.$broadcast('dialogs:close');
      }
    }
  }
});