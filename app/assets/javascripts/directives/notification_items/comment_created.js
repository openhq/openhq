angular.module("OpenHq").directive("commentCreatedNotification", function() {
  return {
    restrict: "E",
    scope: {
      notification: '=',
    },
    template: JST['templates/directives/notification_items/comment_created'],

    controller: function($scope) {
    }
  }
});