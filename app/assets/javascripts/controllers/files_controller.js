angular.module("OpenHq").controller("FilesController", function($scope, Attachment) {
  Attachment.query().then(function(resp) {
    $scope.files = resp;
  });
});
