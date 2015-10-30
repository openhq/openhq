angular.module("OpenHq").controller("StoryController", function($scope, $routeParams, Story, CurrentUser, Comment, Task) {
  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  Story.get($routeParams.slug).then(function(story) {
    $scope.newComment = new Comment({story_id: story.id });
    $scope.newTask = new Task({story_id: story.id });

    // Wrap all tasks in models
    story.tasks = _.map(story.tasks, function(taskData) {
      return new Task(taskData);
    });

    // Wrap all comments in models
    story.comments = _.map(story.comments, function(commentData) {
      return new Comment(commentData);
    });

    $scope.story = story;
  })

  $scope.createComment = function(newComment) {
    newComment.create().then(function(resp) {
      $scope.story.comments.push(resp);
    });
  }

  $scope.createTask = function(newTask) {
    newTask.create().then(function(resp) {
      $scope.story.tasks.push(resp);
    });
  }
});
