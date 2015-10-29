angular.module("OpenHq").controller("ProjectController", function($scope, $routeParams, Restangular) {
  Restangular.one("projects", $routeParams.slug).get().then(function(project) {
    $scope.project = project;
  });
});
