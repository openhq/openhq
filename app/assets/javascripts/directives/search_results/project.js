angular.module("OpenHq").directive("searchResultProject", function() {
  return {
    restrict: "E",
    scope: {
      result: '=',
    },
    template: JST['templates/directives/search_results/project']
  }
});