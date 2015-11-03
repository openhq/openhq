angular.module("OpenHq").controller("StoryController", function($scope, $rootScope, $routeParams, Task, StoriesRepository, Story, CurrentUser, Comment) {
  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  StoriesRepository.find($routeParams.slug).then(function(story) {
    $scope.newComment = new Comment({story_id: story.id });
    $scope.newTask = new Task({story_id: story.id, assigned_to: 0 });
    $scope.story = story;
  });

  StoriesRepository.collaborators($routeParams.slug).then(function(collaborators) {
    $scope.collaborators = collaborators;
  });

  $scope.createComment = function(newComment) {
    newComment.create().then(function(resp) {
      console.log("comment created", resp);
      $scope.story.comments.push(resp);
    });
  }

  $scope.createTask = function(newTask) {
    newTask.create().then(function(resp) {
      $scope.story.tasks.push(resp);
      $scope.newTask = new Task({story_id: $scope.story.id, assigned_to: 0});
    });
  }

  $rootScope.$on('task:deleted', function(_ev, task_id){
    $scope.story.tasks = _.reject($scope.story.tasks, function(task){
      return task.id == task_id;
    });
  });
});
