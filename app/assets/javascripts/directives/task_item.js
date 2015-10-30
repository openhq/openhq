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

      $scope.updateTask = function($event, task) {
        var $form = $($event.currentTarget),
            update_params = {
              id: task.id,
              label: $form.find('input.task_label').val(),
              assigned_to: $form.find('select.task_assignment').val(),
              due_at: $form.find('input.task_due_at').val()
            };

        new Task(update_params).update().then(function(resp){
          task.label = resp.label;
          task.due_at_pretty = resp.due_at_pretty;
          task.assignment_name = resp.assignment_name;

          $scope.stopEditing($event);
        }, function(errors) {
          console.error(errors);
        });
      }

      $scope.deleteTask = function($event, task) {
        var $list_item = $($event.currentTarget).closest('li'),
            c = confirm("Are you sure you want to delete this task?");

        if (!c) return;

        new Task(task).delete().then(function(){
          $list_item.remove();
        });
      }
    }
  };
});