angular.module("OpenHq").directive("errorList", function() {
  return {
    restrict: "E",
    scope: {
      errors: '='
    },
    template: JST['templates/directives/error_list']
  }
});