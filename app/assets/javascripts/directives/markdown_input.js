angular.module("OpenHq").directive("markdownInput", function() {
  return {
    restrict: "E",
    scope: {
      content: '=',
      filler: '=',
    },
    template: JST['templates/directives/markdown_input']
  };
});
