angular.module("OpenHq").directive("taskItem", function(Task) {
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

      $scope.deleteTask = function(task) {
        console.log('delete task', task);
      }

      $scope.updateTask = function($event, task) {
        var $form = $($event.currentTarget);

        task.label = $form.find('input.task_label').val();
        task.assigned_to = $form.find('select.task_assignment').val();
        task.assignment_name = $form.find('select.task_assignment option:selected').html();
        task.due_at = $form.find('input.task_due_at').val();
        task.due_at_pretty = $form.find('input.task_due_at').val();

        new Task(task).update();
        $scope.stopEditing($event);
      }
    }
  };
});