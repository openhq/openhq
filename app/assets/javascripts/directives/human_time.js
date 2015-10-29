angular.module("OpenHq").directive("humanTime", function() {
    return {
        scope: {
          datetime: '=',
        },
        link: function($scope, el){
            $(el).html($.timeago($scope.datetime));
        }
    };
});