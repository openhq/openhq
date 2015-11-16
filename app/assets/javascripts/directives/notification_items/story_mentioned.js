angular.module("OpenHq").directive("storyMentionedNotification", function() {
  return {
    restrict: "E",
    scope: {
      notification: '=',
    },
    template: JST['templates/directives/notification_items/story_mentioned'],

    controller: function($scope) {
    }
  }
});