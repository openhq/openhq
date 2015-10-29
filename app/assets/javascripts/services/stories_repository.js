angular.module("OpenHq").factory("storiesRepository", function(Restangular) {
  return Restangular.all('stories');
});
