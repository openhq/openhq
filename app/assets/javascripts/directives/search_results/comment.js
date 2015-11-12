angular.module("OpenHq").directive("searchResultComment", function() {
  return {
    restrict: "E",
    scope: {
      result: '=',
    },
    template: JST['templates/directives/search_results/comment']
  }
});