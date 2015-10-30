angular.module("OpenHq").controller("ProjectsController", function($scope, Project) {
  $scope.newProject = new Project();

  Project.query().then(function(projects) {
    $scope.projects = projects;
  });

  $scope.createProject = function(newProject) {
    newProject.create().then(function(project) {
      $scope.projects.push(project);
    });
  };
});
