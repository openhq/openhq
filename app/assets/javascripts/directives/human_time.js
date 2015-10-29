angular.module("OpenHq").directive("humanTime", function() {
    return {
        restrict: "E",
        scope: {
          datetime: '=',
        },
        template: "<abbr title='{{ datetime }}'>{{ datetime }}</abbr>",
        link: function($scope, el){
            $scope.$watch('datetime', function(){
                $(el).find('abbr').timeago();
            });
        },
    };
});