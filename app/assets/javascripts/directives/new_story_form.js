angular.module("OpenHq").directive("newStoryForm", function() {
    return {
        restrict: "E",
        scope: {
          user: '=',
          story: '=',
          title: '=',
          content: '=',
          button: '=',
          projectId: '=',
        },
        template: JST['templates/directives/new_story_form']
    };
});