angular.module("OpenHq").controller("ManageProjectController", function($scope, $rootScope, $routeParams, $location, Project) {
  Project.get($routeParams.slug).then(function(project) {
    $scope.project = project;
  });

  $scope.archiveProject = function() {
    $rootScope.confirm('Archive Project', 'Are you sure?', function(){
      $scope.project.delete().then(function(resp){
        // TODO: add a notification
        $location.url('/');
      });
    });
  };
});
