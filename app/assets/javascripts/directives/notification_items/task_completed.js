angular.module("OpenHq").directive("taskCompletedNotification", function() {
  return {
    restrict: "E",
    scope: {
      notification: '=',
    },
    template: JST['templates/directives/notification_items/task_completed'],

    controller: function($scope) {
    }
  }
});