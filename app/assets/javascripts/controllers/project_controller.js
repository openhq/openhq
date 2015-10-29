angular.module("OpenHq").controller("ProjectController", function($scope, $routeParams, Restangular, storiesRepository) {
  Restangular.one("projects", $routeParams.slug).get().then(function(project) {
    $scope.project = project;
  });

  storiesRepository.getList({project_id: $routeParams.slug}).then(function(stories) {
    $scope.stories = stories;
  });
});
