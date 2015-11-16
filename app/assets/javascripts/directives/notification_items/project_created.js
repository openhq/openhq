angular.module("OpenHq").directive("projectCreatedNotification", function() {
  return {
    restrict: "E",
    scope: {
      notification: '=',
    },
    template: JST['templates/directives/notification_items/project_created'],

    controller: function($scope) {
    }
  }
});