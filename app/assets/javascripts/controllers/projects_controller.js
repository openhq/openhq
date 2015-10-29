angular.module("OpenHq").controller("ProjectsController", function($scope, projectsRepository) {
  $scope.newProject = {};
  $scope.projects = projectsRepository.getList().$object;

  $scope.createProject = function(newProject) {
    projectsRepository.post({project: newProject}).then(function(project) {
      $scope.projects.push(project);
    });
  };
});
