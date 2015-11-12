angular.module("OpenHq").directive("searchResultTask", function() {
  return {
    restrict: "E",
    scope: {
      result: '=',
    },
    template: JST['templates/directives/search_results/task'],
  }
});