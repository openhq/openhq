angular.module("OpenHq").controller("NewStoryController", function($scope, $rootScope, $routeParams, $location, Story, Project, Task, CurrentUser) {
  $scope.projectId = $routeParams.slug;
  $scope.story = new Story({project_id: $scope.projectId, story_type: "todo"});

  $scope.story.tasks = [];
  $scope.newTask = new Task({ assigned_to: 0 });

  Project.get($routeParams.slug).then(function(project) {
    $scope.project = project;
  });

  CurrentUser.get(function(user) {
    $scope.currentUser = user;
  });

  $scope.addTask = function(task) {
    task.id = "new-item:" + Math.random(99999999);
    $scope.story.tasks.push(angular.copy(task));

    // Reset the new task
    $scope.newTask = new Task({ assigned_to: 0 });
  };

  $scope.createStory = function(story) {
    story.create().then(function(story) {
      $location.path("/todos/"+story.slug);
    });
  };

  $rootScope.$on('task:deleted', function(_ev, task_id){
    $scope.story.tasks = _.reject($scope.story.tasks, function(task){
      return task.id == task_id;
    });
  });
});
