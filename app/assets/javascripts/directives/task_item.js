angular.module("OpenHq").directive("taskItem", function($rootScope, $routeParams, Task, TasksRepository, ConfirmDialog) {
  return {
    restrict: "E",
    scope: {
      task: '=',
      users: '=',
    },
    template: JST['templates/directives/task_item'],

    controller: function($scope){
      $scope.editTask = angular.copy($scope.task);
      $scope.editing = false;
      $scope.$task_list = $(".tasks ul.sortable");

      $scope.startEditing = function() {
        $scope.editing = true;
      };

      $scope.stopEditing = function() {
        $scope.editing = false;
      };

      $scope.updateTask = function() {
        new Task($scope.editTask).update().then(function(resp){
          $scope.task = resp;
          $scope.stopEditing();
        }, function(errors) {
          console.error(errors);
        });
      };

      $scope.deleteTask = function() {
        ConfirmDialog.show('Delete Task', 'Are you sure you want to delete this task?').then(function(){
          new Task($scope.task).delete().then(function(){
            $rootScope.$broadcast('task:deleted', $scope.task.id);
          });
        });
      };

      $scope.$watch("task.completed", function(newValue, oldValue) {
        if (newValue !== oldValue) {
          $scope.task.update();
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
          var story_id = $routeParams.slug,
              order = $(this).sortable("toArray");

          TasksRepository.updateOrder(story_id, order);
        }
      });
    }
  };
});
