angular.module("OpenHq").directive("taskItem", function($rootScope, $routeParams, $location, Task, TasksRepository, ConfirmDialog) {
  return {
    restrict: "E",
    scope: {
      task: '=',
      users: '=',
      singleView: '=' // viewing on its own, or in an overall list
    },
    template: JST['templates/directives/task_item'],

    controller: function($scope){
      $scope.editTask = angular.copy($scope.task);
      $scope.editing = false;
      $scope.task.completeInline = false; // still show the task, even if it is completed
      $scope.$task_list = $(".tasks ul.sortable");
      $scope.isNewStory = $('.tasks').hasClass('new-story');

      // Sets a pretty due at date if it hasnt been passed through
      $scope.setDueAtPretty = function() {
        if (_.isUndefined($scope.task.due_at)) {
          $scope.task.due_at_pretty = null;
        } else {
          var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
              date = new Date($scope.task.due_at);
          $scope.task.due_at_pretty = date.getDate() + " " + months[date.getMonth()] + ", " + date.getFullYear();
        }
      };
      if (_.isUndefined($scope.task.due_at_pretty)) $scope.setDueAtPretty();

      // Sets a assignment name if it hasnt been passed through
      $scope.setAssignmentName = function() {
        console.log("USERS:", $scope.users);
        var user = _.find($scope.users, function(u){
          return u[1] === $scope.task.assigned_to;
        });

        $scope.task.assignment_name = user[0];
      };
      if (_.isUndefined($scope.task.assignment_name)) $scope.setAssignmentName();

      $scope.loadTask = function() {
        console.log('single view?', $scope.singleView);
        $location.url('/todos/'+$routeParams.slug+'/task/'+$scope.task.id);
      };

      $scope.startEditing = function() {
        $scope.editing = true;
      };

      $scope.stopEditing = function() {
        $scope.editing = false;
      };

      $scope.updateTask = function() {
        if ($scope.isNewStory) {
          $scope.task = $scope.editTask;
          $scope.setAssignmentName();
          $scope.setDueAtPretty();
          $scope.stopEditing();
        } else {
          new Task($scope.editTask).update().then(function(resp){
            $scope.task = resp;
            $scope.stopEditing();
          }, function(errors) {
            console.error(errors);
          });
        }
      };

      $scope.deleteTask = function() {
        if ($scope.isNewStory) {
          $rootScope.$broadcast('task:deleted', $scope.task.id);
        } else {
          ConfirmDialog.show('Delete Task', 'Are you sure you want to delete this task?').then(function(){
            new Task($scope.task).delete().then(function(){
              $rootScope.$broadcast('task:deleted', $scope.task.id);
            });
          });
        }
      };

      $scope.$watch("task.completed", function(newValue, oldValue) {
        if (newValue !== oldValue) {
          $scope.task.completeInline = true;
          $scope.task.update();
          $rootScope.$broadcast('story:taskCompleted');
        }
      });

      // Remove sortable if already initalized
      if ($scope.$task_list.hasClass('ui-sortable')) {
        $scope.$task_list.sortable("destroy");
      }

      // Set updated list as sorted
      $scope.$task_list.sortable({
        items: "li",
        update: function() {
          if ($scope.isNewStory) return;

          var story_id = $routeParams.slug,
              order = $(this).sortable("toArray");

          TasksRepository.updateOrder(story_id, order);
        }
      });
    }
  };
});
