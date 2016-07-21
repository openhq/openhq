angular.module("OpenHq").controller("ProjectController", function($scope, $routeParams, Project, Story) {
  $scope.addNewListShowing = false;

  Project.get($routeParams.slug).then(function(project) {
    $scope.project = project;
  });

  Story.query({project_id: $routeParams.slug}).then(function(stories) {
    $scope.stories = stories;
  })

  $scope.toggleAddNewList = function() {
    $scope.addNewListShowing = !$scope.addNewListShowing;
  };
});
