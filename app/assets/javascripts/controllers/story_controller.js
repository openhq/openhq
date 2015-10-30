angular.module("OpenHq").controller("StoryController", function($scope, $routeParams, Story, CurrentUser, Comment) {
  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  Story.get($routeParams.slug).then(function(story) {
    $scope.story = story;
    $scope.newComment = new Comment({story_id: $scope.story.id });
  })

  $scope.createComment = function(newComment) {
    newComment.create().then(function(resp) {
      console.log("comment created", resp);
      $scope.story.comments.push(resp);
    });
  }
});
