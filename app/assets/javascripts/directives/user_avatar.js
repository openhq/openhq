angular.module("OpenHq").directive("userAvatar", function() {
    return {
        restrict: "E",
        scope: {
          user: '=',
          size: '=',
        },
        template: JST['templates/directives/user_avatar'],
    };
});