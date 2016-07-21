angular.module("OpenHq").controller("TaskController", function($scope, $routeParams, $location, StoriesRepository, Task) {
  $scope.tasks = [];

  StoriesRepository.find($routeParams.slug).then(function(story){
    $scope.story = story;

    // We can get the task from the list on the story
    var task = _.find(story.tasks, function(t){
      return parseInt(t.id, 10) === parseInt($routeParams.task_id, 10);
    });

    $scope.tasks.push(task);

    // Send user back to the todo list, if we cant find the task
    if (_.isUndefined(task)) $location.url('/todos/'+$routeParams.slug);
  });
});
