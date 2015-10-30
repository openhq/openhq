angular.module("OpenHq").controller("ProjectsController", function($scope, ProjectsRepository) {
  $scope.newProject = {};
  $scope.projects = ProjectsRepository.all().$object;

  $scope.createProject = function(newProject) {
    ProjectsRepository.create(newProject).then(function(project) {
      $scope.projects.push(project);
    });
  };
});
