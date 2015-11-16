angular.module("OpenHq").directive("taskCreatedNotification", function() {
  return {
    restrict: "E",
    scope: {
      notification: '=',
    },
    template: JST['templates/directives/notification_items/task_created'],

    controller: function($scope) {
    }
  }
});