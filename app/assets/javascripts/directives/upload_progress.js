angular.module("OpenHq").directive("uploadProgress", function() {
  return {
    restrict: "EA",
    scope: {
      file: '='
    },
    template: JST['templates/directives/upload_progress'],
    controller: function($scope) {
      // $scope.$watch("file.uploadProgress", function() {
      //   console.log("uploadProgress directive seen change");
      // })
    }
  };
});
