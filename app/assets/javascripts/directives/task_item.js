angular.module("OpenHq").directive("taskItem", function($rootScope, Task) {
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

      $scope.startEditing = function() {
        $scope.editing = true;
      }

      $scope.stopEditing = function() {
        $scope.editing = false;
      }

      $scope.updateTask = function() {
        $scope.editTask.due_at = $scope.editTask.due_at_pretty;

        new Task($scope.editTask).update().then(function(resp){
          $scope.task = resp;
          $scope.stopEditing();
        }, function(errors) {
          console.error(errors);
        });
      }

      $scope.deleteTask = function($event) {
        var c = confirm("Are you sure you want to delete this task?");
        if (!c) return;

        new Task($scope.task).delete().then(function(){
          $rootScope.$broadcast('task:deleted', $scope.task.id);
        });
      }
    }
  };
});