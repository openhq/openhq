angular.module("OpenHq").directive("taskItem", function() {
  return {
    restrict: "E",
    scope: {
      task: '=',
      users: '=',
    },
    template: JST['templates/directives/task_item'],

    controller: function($scope){
      $scope.editing = false;

      $scope.startEditing = function($event) {
        $scope.editing = true;
        $($event.currentTarget).closest('li').addClass('editing');
      }

      $scope.stopEditing = function($event) {
        $scope.editing = false;
        $($event.currentTarget).closest('li').removeClass('editing');
      }

      $scope.deleteTask = function($event) {
        console.log('delete that thang');
      }

      $scope.updateTask = function($event) {
        $event.preventDefault();
        console.log('update thon task');
      }
    }
  };
});