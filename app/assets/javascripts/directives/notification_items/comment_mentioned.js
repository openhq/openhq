angular.module("OpenHq").directive("commentMentionedNotification", function() {
  return {
    restrict: "E",
    scope: {
      notification: '=',
    },
    template: JST['templates/directives/notification_items/comment_mentioned'],

    controller: function($scope) {
    }
  }
});