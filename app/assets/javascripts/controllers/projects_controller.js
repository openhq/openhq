angular.module("OpenHq").controller("ProjectsController", function($scope, Project) {
  $scope.projects = Project.getList().$object;
});
