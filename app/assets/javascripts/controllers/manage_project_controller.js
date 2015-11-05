angular.module("OpenHq").controller("ManageProjectController", function($scope, $routeParams, $location, Project) {
  Project.get($routeParams.slug).then(function(project) {
    $scope.project = project;
  });

  $scope.archiveProject = function() {
    var c = confirm("Are you sure you want to archive this project?");
    if (!c) return;

    $scope.project.delete().then(function(resp){
      // TODO: add a notification
      $location.url('/');
    });
  };
});
