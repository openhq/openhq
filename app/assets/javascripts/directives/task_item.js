angular.module("OpenHq").directive("taskItem", function() {
    return {
        restrict: "E",
        scope: {
          task: '=',
        },
        template: JST['templates/directives/task_item']
    };
});