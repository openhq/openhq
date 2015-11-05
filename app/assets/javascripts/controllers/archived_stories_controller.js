angular.module("OpenHq").controller("ArchivedStoriesController", function($scope, $routeParams, $location, ProjectsRepository) {

  ProjectsRepository.archived_stories($routeParams.slug).then(function(archived_stories) {
    $scope.archived_stories = archived_stories;
  });

});