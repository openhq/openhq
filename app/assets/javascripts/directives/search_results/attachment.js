angular.module("OpenHq").directive("searchResultAttachment", function() {
  return {
    restrict: "E",
    scope: {
      result: '=',
    },
    template: JST['templates/directives/search_results/attachment']
  }
});