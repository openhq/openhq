angular.module("OpenHq").controller("ProjectsController", function($scope, Project, projects) {
  $scope.newProject = new Project();
  $scope.projects = projects;

  $scope.createProject = function(newProject) {
    newProject.create().then(function(project) {
      $scope.projects.push(project);
    });
  };
});
