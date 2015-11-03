angular.module("OpenHq").controller("NewStoryController", function($scope, $routeParams, $location, Story, CurrentUser) {
  $scope.projectId = $routeParams.slug;
  $scope.story = new Story({project_id: $scope.projectId});

  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  $scope.createStory = function(story) {
    story.create().then(function(story) {
      $location.path("/stories/"+story.slug);
    });
  };
});
