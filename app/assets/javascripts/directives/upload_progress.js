angular.module("OpenHq").directive("uploadProgress", function() {
  return {
    restrict: "EA",
    scope: {
      file: '='
    },
    template: JST['templates/directives/upload_progress']
  };
});
