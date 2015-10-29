angular.module("OpenHq").controller("ProjectsController", function($scope, Project) {
  $scope.newProject = {};
  $scope.projects = Project.getList().$object;

  $scope.createProject = function(newProject) {
    Project.post(newProject).then(function(project) {
      $scope.projects.push(project);
    });
  };
});
