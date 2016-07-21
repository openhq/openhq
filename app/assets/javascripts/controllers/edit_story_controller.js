angular.module("OpenHq").controller("EditStoryController", function($scope, $routeParams, $location, Story) {
  Story.get($routeParams.slug).then(function(story) {
    $scope.story = story;
  });

  $scope.saveChanges = function() {
    $scope.story.update().then(function(){
      $location.url('/'+$scope.story.story_type+'s/'+$scope.story.slug);
    });
  };
});
