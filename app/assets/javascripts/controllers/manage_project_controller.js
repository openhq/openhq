angular.module("OpenHq").controller("ManageProjectController", function($scope, $rootScope, $routeParams, $location, Project, ConfirmDialog) {
  Project.get($routeParams.slug).then(function(project) {
    $scope.project = project;
  });

  $scope.archiveProject = function() {
    ConfirmDialog.show('Archive Project', 'Are you sure you want to archive this project?').then(function(){
      $scope.project.delete().then(function(resp){
        // TODO: add a notification
        $location.url('/');
      });
    });
  };
});
