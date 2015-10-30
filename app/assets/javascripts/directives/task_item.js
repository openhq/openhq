angular.module("OpenHq").directive("taskItem", function() {
    return {
        restrict: "E",
        scope: {
          task: '=',
          users: '=',
        },
        template: JST['templates/directives/task_item'],
        controller: function($scope){
            console.log($scope.users);
        }
    };
});