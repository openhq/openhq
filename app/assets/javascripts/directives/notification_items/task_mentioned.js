angular.module("OpenHq").directive("taskMentionedNotification", function() {
  return {
    restrict: "E",
    scope: {
      notification: '=',
    },
    template: JST['templates/directives/notification_items/task_mentioned'],

    controller: function($scope) {
    }
  }
});