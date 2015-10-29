angular.module("OpenHq").directive("userAvatar", function() {
    return {
        restrict: "E",
        scope: {
          user: '=',
        },
        template: "<img src='{{ user.avatar_url }}' alt='{{ user.display_name }}'>",
    };
});