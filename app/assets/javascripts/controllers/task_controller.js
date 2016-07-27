angular.module("OpenHq").controller("TaskController", function($scope, $rootScope, $routeParams, $location, CurrentUser, StoriesRepository, TasksRepository) {
  $scope.tasks = [];

  // Sets the current user
  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  // Gets the task - includes with the comments
  TasksRepository.find($routeParams.task_id).then(function(task){
    $scope.tasks.push(task);

    $rootScope.$on('comment:created', function(_ev, comment) {
      if (comment.commentable_type === "Task" && comment.commentable_id === task.id) {
        task.comments.push(comment);
      }
    });

    $rootScope.$on('comment:deleted', function(_ev, comment) {
      if (comment.commentable_type === "Task" && comment.commentable_id === task.id) {
        task.comments = _.reject(task.comments, function(c) {
          return c.id == comment.id;
        });
      }
    });
  });

  // Set the story and ensure the task exists
  StoriesRepository.find($routeParams.slug).then(function(story){
    $scope.story = story;

    // We can get the task from the list on the story
    var task = _.find(story.tasks, function(t){
      return parseInt(t.id, 10) === parseInt($routeParams.task_id, 10);
    });

    // Send user back to the todo list, if we cant find the task on this story
    if (_.isUndefined(task)) $location.url('/todos/'+$routeParams.slug);
  });
});
