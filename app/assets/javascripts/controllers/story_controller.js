angular.module("OpenHq").controller("StoryController", function($scope, $routeParams, Story, CurrentUser) {

  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  Story.get($routeParams.slug).then(function(story) {
    $scope.story = story;
  })
});
