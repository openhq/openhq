angular.module("OpenHq").controller("ProjectController", function($scope, $routeParams, Restangular, ProjectsRepository, StoriesRepository) {
  $scope.project = ProjectsRepository.find($routeParams.slug).$object;
  $scope.stories = StoriesRepository.all({project_id: $routeParams.slug}).$object;
});
