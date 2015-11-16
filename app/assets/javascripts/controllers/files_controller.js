angular.module("OpenHq").controller("FilesController", function($scope, AttachmentsRepository) {
  $scope.page = 1;
  $scope.files = [];
  $scope.meta = {};

  function loadResults() {
    AttachmentsRepository.all($scope.page).then(function(resp) {
      console.log("files", resp);

      $scope.meta = resp.meta;

      resp.attachments.forEach(function(file) {
        $scope.files.push(file);
      });
    });
  }

  $scope.loadMore = function() {
    $scope.page++;
    loadResults();
    console.log("Loading more results");
  };

  loadResults();
});
