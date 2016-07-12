angular.module("OpenHq").directive("newStoryForm", function() {
    return {
        restrict: "E",
        scope: {
          user: '=',
          projectId: '=',
          story: '=',
          type: '=',
          title: '=',
          content: '=',
          button: '=',
        },
        template: JST['templates/directives/new_story_form'],

        controller: function($scope, $location) {
          $scope.createStory = function(story) {
            story.story_type = $scope.story_type;
            story.create().then(function(story) {
              $location.path("/"+story.story_type+"/"+story.slug);
            });
          }
        }
    };
});