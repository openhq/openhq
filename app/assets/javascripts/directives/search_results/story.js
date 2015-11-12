angular.module("OpenHq").directive("searchResultStory", function() {
  return {
    restrict: "E",
    scope: {
      result: '=',
    },
    template: JST['templates/directives/search_results/story']
  }
});