angular.module("OpenHq").directive("taskItem", function() {
    return {
        restrict: "E",
        scope: {
          task: '=',
        },
        template: JST['templates/directives/task_item'],
        controller: function($scope, Task) {
            $scope.$watch("task.completed", function(newValue, oldValue) {
                if (newValue !== oldValue) {
                    $scope.task.update();
                }
            });
        },
    };
});
