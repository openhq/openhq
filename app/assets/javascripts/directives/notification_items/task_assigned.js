angular.module("OpenHq").directive("taskAssignedNotification", function() {
  return {
    restrict: "E",
    scope: {
      notification: '=',
    },
    template: JST['templates/directives/notification_items/task_assigned'],

    controller: function($scope) {
    }
  }
});