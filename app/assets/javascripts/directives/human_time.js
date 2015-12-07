angular.module("OpenHq").directive("humanTime", function() {
  return {
    restrict: "E",
    scope: {
      datetime: '=',
    },
    template: "<abbr title='{{ datetime }}'>{{ datetime }}</abbr>",
    link: function($scope, el){
      $scope.$watch('datetime', function(){
        if ($scope.datetime) $(el).find('abbr').timeago();
      });
    },
  };
});
