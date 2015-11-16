angular.module("OpenHq").directive("storyCreatedNotification", function() {
  return {
    restrict: "E",
    scope: {
      notification: '=',
    },
    template: JST['templates/directives/notification_items/story_created'],

    controller: function($scope) {
    }
  }
});