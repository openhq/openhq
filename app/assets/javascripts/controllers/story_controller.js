angular.module("OpenHq").controller("StoryController", function($scope, $rootScope, $routeParams, Story, CurrentUser, Comment) {
  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  Story.get($routeParams.slug).then(function(story) {
    $scope.story = story;
    $scope.newComment = new Comment({story_id: $scope.story.id });
  });

  $scope.createComment = function(newComment) {
    newComment.create().then(function(resp) {
      console.log("comment created", resp);
      $scope.story.comments.push(resp);
    });
  }

  $rootScope.$on('task:deleted', function(_ev, task_id){
    $scope.story.tasks = _.reject($scope.story.tasks, function(task){
      return task.id == task_id;
    });
  })
});
